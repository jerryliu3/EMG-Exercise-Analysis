#cALCULATE FEATURES

import math
import scipy as sp
from scipy.stats import kurtosis, skew
import sklearn
import numpy as np
import pandas as pd

data = pd.read_csv('Elbowing.txt', sep="\t", header=None)
#data.columns = ["R_BI", "R_TRI", "L_BI", "L_TRI", "R_THI", "R_HAM", "L_THI", "L_HAM"]
elbow = data[0:700]

data = pd.read_csv('Frontkicking.txt', sep="\t", header=None)
frontKick = data[0:700]

data = pd.read_csv('Hamering.txt', sep="\t", header=None)
hamering = data[0:700]

data = pd.read_csv('Headering.txt', sep="\t", header=None)
headering = data[0:700]

frames = [elbow, frontKick, hamering, headering]
#combined = pd.concat(frames)
#np.shape(combined)
def appendEnergyVector(dataFrame):
    #take in the dataFrame, set new columns as a^2 + b^2 for each pair of 2. 
    energyCols = [8, 9, 10, 11]
    i = 0
    for col in energyCols:
        dataFrame[col] = np.square(dataFrame[i])+np.square(dataFrame[i+1])
        i = i+2
    return dataFrame

elbow = appendEnergyVector(elbow)
frontKick = appendEnergyVector(frontKick)
hamering = appendEnergyVector(hamering)
headering = appendEnergyVector(headering)


#Mean crossings
def meanCrossing(frame):
    centeredFrame = frame - np.mean(frame)
    return ((centeredFrame[0][:-1].values * centeredFrame[0][1:].values) < 0).sum()


#4 bin histogram: It's actually 4 features. The bins are range/4. Check frequency of each bin for each feature. 
def fourBin(frame):
    allBins = np.histogram(frame[0],bins=4)[0][:]
    for i in range(1,12):
        allBins = np.append(allBins, np.histogram(frame[i],bins=4)[0][:])
    return allBins

featMean = np.empty([4,12])
featVar = np.empty([4,12])
featStd = np.empty([4,12])
featMin = np.empty([4,12])
featMax = np.empty([4,12])
featSkew = np.empty([4,12])
featKurtosis = np.empty([4,12])
featMeanCrossing = np.empty([4,12])
featMeanSpectralEnergy = np.empty([4,12], dtype=complex)
featFourBin = np.empty([4,48])

i=0
for frame in frames:
    featMean[i][:] = np.mean(frame).values.reshape([1,12])
    featVar[i][:] = np.var(frame).values.reshape([1,12])
    featStd[i][:] = np.std(frame).values.reshape([1,12])
    featMin[i][:] = np.min(frame).values.reshape([1,12])
    featMax[i][:] = np.max(frame).values.reshape([1,12])
    featSkew[i][:] = skew(frame)
    featKurtosis[i][:] = kurtosis(frame)
    featMeanCrossing[i][:] = meanCrossing(frame)
    featMeanSpectralEnergy[i][:] = np.mean(np.square(np.fft.fft(frame)),0)
    featFourBin[i][:] = fourBin(frame)
    i = i+1

allFeats = featMean
features = [featVar, featStd, featMin, featMax, featSkew, featKurtosis, featMeanCrossing, featMeanSpectralEnergy, featFourBin]
for feature in features:
    allFeats = np.append(allFeats, feature, axis=1)

print(np.shape(allFeats)) #4 samples by (12 channels by 13 features) = 4 x 156

#TRAIN CLASSIFIERS
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm

#Random Forest
#Create and train classifier
y = np.reshape([1,2,3,4],[4,1])
#Train classifier. 
clfRf = RandomForestClassifier(n_jobs=2,random_state=0) #n_jobs to run in parallel. 
#Random_state is the seed used for the random number generator. 
clfRf.fit(allFeats,y)

#Support Vector Classifier
clfSvc = svm.SVC(kernel='linear')
clfSvc.fit(allFeats,y)

#MAKE TESTING DATA
indexStart = 700
indexStop = 1400

data = pd.read_csv('Elbowing.txt', sep="\t", header=None)
#data.columns = ["R_BI", "R_TRI", "L_BI", "L_TRI", "R_THI", "R_HAM", "L_THI", "L_HAM"]
elbow = data[indexStart:indexStop]

data = pd.read_csv('Frontkicking.txt', sep="\t", header=None)
frontKick = data[indexStart:indexStop]

data = pd.read_csv('Hamering.txt', sep="\t", header=None)
hamering = data[indexStart:indexStop]

data = pd.read_csv('Headering.txt', sep="\t", header=None)
headering = data[indexStart:indexStop]

frames = [elbow, frontKick, hamering, headering]

def appendEnergyVector(dataFrame):
    #take in the dataFrame, set new columns as a^2 + b^2 for each pair of 2. 
    energyCols = [8, 9, 10, 11]
    i = 0
    for col in energyCols:
        dataFrame[col] = np.square(dataFrame[i])+np.square(dataFrame[i+1])
        i = i+2
    return dataFrame

elbow = appendEnergyVector(elbow)
frontKick = appendEnergyVector(frontKick)
hamering = appendEnergyVector(hamering)
headering = appendEnergyVector(headering)

#Build feature vector for testing data

featMean = np.empty([4,12])
featVar = np.empty([4,12])
featStd = np.empty([4,12])
featMin = np.empty([4,12])
featMax = np.empty([4,12])
featSkew = np.empty([4,12])
featKurtosis = np.empty([4,12])
featMeanCrossing = np.empty([4,12])
featMeanSpectralEnergy = np.empty([4,12], dtype=complex)
featFourBin = np.empty([4,48])

i=0
for frame in frames:
    featMean[i][:] = np.mean(frame).values.reshape([1,12])
    featVar[i][:] = np.var(frame).values.reshape([1,12])
    featStd[i][:] = np.std(frame).values.reshape([1,12])
    featMin[i][:] = np.min(frame).values.reshape([1,12])
    featMax[i][:] = np.max(frame).values.reshape([1,12])
    featSkew[i][:] = skew(frame)
    featKurtosis[i][:] = kurtosis(frame)
    featMeanCrossing[i][:] = meanCrossing(frame)
    featMeanSpectralEnergy[i][:] = np.mean(np.square(np.fft.fft(frame)),0)
    featFourBin[i][:] = fourBin(frame)
    i = i+1

allFeats = featMean
features = [featVar, featStd, featMin, featMax, featSkew, featKurtosis, featMeanCrossing, featMeanSpectralEnergy, featFourBin]
for feature in features:
    allFeats = np.append(allFeats, feature, axis=1)

print(np.shape(allFeats)) #4 samples by (12 channels by 13 features) = 4 x 156

clfRf.predict(allFeats)

clfRf.predict_proba(allFeats)

y_test = [[1],[2],[3],[4]]
clfRf.score(allFeats, y_test)

featureDf = pd.DataFrame(allFeats)
featureDf[0:155].head()
importances = list(zip(featureDf[0:155], clf.feature_importances_))
importances.sort(key=lambda x: x[1], reverse=True)
importances[0:20]

preds = clfSvc.predict(allFeats)
preds

y_test = [[1],[2],[3],[4]]
clfSvc.score(allFeats, y_test)

#DEPRECIATED
#np.var(elbow)
#np.std(elbow)
#np.min(elbow)
#np.max(elbow)
#skew(elbow)
#kurtosis(elbow)
#Mean crossings
#centeredElbow = elbow - means
#((centeredElbow[0][:-1].values * centeredElbow[0][1:].values) < 0).sum()
#Mean spectral energy
#fourier = np.fft.fft(elbow)
#uSpectralEnergy = np.mean(np.square(fourier),0)
#print(uSpectralEnergy)
#Test classifier by passing in 700 new values from something, getting the features, then predicing.