import seglearn as sgl

from seglearn.transform import FeatureRep, SegmentX
from seglearn.pipe import SegPipe
from seglearn.datasets import load_watch

from sklearn.pipeline import Pipeline
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split, cross_validate
from sklearn.metrics import f1_score, confusion_matrix, make_scorer

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import itertools

###################################################################################################

def plot_embedding(emb, y, y_labels):
    # plot a 2D feature map embedding
    x_min, x_max = np.min(emb, 0), np.max(emb, 0)
    emb = (emb - x_min) / (x_max - x_min)

    NC = len(y_labels)
    markers = ['.','+','x','|','_','*','o','v','^','<']

    fig = plt.figure()
    fig.set_size_inches(6,6)
    print(emb)
    print(np.shape(emb))
    for c in range(NC):
        i = y == c
        plt.scatter(emb[i, 0], emb[i, 1], marker=markers[c], label = y_labels[c])

    plt.xticks([]), plt.yticks([])
    plt.legend()
    plt.tight_layout()

def plot_confusion_matrix(cm, classes,
                          normalize=True,
                          cmap=plt.cm.Blues):
    ''' plots confusion matrix '''
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)
    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.tight_layout()

###################################################################################################

# read the data
X = np.array([np.array(pd.read_csv('back_pulldown_narrow.csv', sep=",", header=None)),
              np.array(pd.read_csv('back_pulldown_wide.csv', sep=",", header=None)),
              np.array(pd.read_csv('back_row.csv', sep=",", header=None)),
              np.array(pd.read_csv('bicep_curl_alternating.csv', sep=",", header=None)),
              np.array(pd.read_csv('bicep_curl_simultaneous.csv', sep=",", header=None)),
              np.array(pd.read_csv('chin_up.csv', sep=",", header=None)),
              np.array(pd.read_csv('pull_up.csv', sep=",", header=None)),
              np.array(pd.read_csv('wrist_curl_left.csv', sep=",", header=None)),
              np.array(pd.read_csv('wrist_curl_right.csv', sep=",", header=None)),
              np.array(pd.read_csv('wrist_curl_simultaneous.csv', sep=",", header=None))])

# create the label vector and the corresponding semantic vector
y = np.array([0,1,2,3,4,5,6,7,8,9])
labels = ['BP_N','BP_W', 'BR', 'BC_A', 'BC_S', 'CU', 'PU', 'WC_L', 'WC_R', 'WC_S']

# segment the data and labels
segmenter = SegmentX(100,0.5)
X_new, y_new, _ = segmenter.fit_transform(X, y)

###################################################################################################

# create a pipeline for LDA transformation of the feature representation
est = Pipeline([ ('features', FeatureRep()),
                 ('lda', LinearDiscriminantAnalysis(n_components=2))])
pipe = SegPipe(est)

# plot embedding
X2, y2 = pipe.fit_transform(X_new, y_new)
plot_embedding(X2, y2.astype(int), labels)
plt.show()

###################################################################################################

# create a pipeline for feature representation
est = Pipeline([('features', FeatureRep()),
                ('scaler', StandardScaler()),
                ('rf', RandomForestClassifier())])
pipe = SegPipe(est)

# split the data
X_train, X_test, y_train, y_test = train_test_split(X_new, y_new, test_size=0.25, random_state=42)
pipe.fit(X_train,y_train)
score = pipe.score(X_test, y_test)
print("Accuracy score: ", score)

y_true, y_pred = pipe.predict(X_test, y_test)
# use any of the sklearn scorers
f1_macro = f1_score(y_true, y_pred, average='macro')
print("F1 score: ", f1_macro)

# plot confusion matrix
cm = confusion_matrix(y_true, y_pred)
plot_confusion_matrix(cm, labels)
plt.show()