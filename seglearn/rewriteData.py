from csv import reader, writer
from itertools import zip_longest
from math import floor
from os import listdir
from os.path import join

def transposeFile(filePath,finalPath,isCreating):
	path = [finalPath,filePath]
	transposed = zip_longest(*reader(open(path[isCreating], "r")))
	writer(open(finalPath, "w", newline='')).writerows(transposed)

def keepSecond(finalPath):
	with open(finalPath, 'r') as f:
		data = list(reader(f))
	with open(finalPath, 'w', newline='') as f:
		filewriter = writer(f)
		filewriter.writerow(data[1])

def splitData(finalPath):
	LB,RB,LF,RF = [],[],[],[]
	with open(finalPath, 'r') as f:
		data = list(reader(f))
		channelRepeats = floor(len(data[0])/4000) # Channel data repeats this many times i.e. number of 1000 data sections
		for i in range(channelRepeats): 
			for j in range(4): # [0,1,2,3]
				section = data[0][i*4000+j*1000:(i*4000+(j+1)*1000)]
				if j == 1: # This corresponds with the mux.ino code
					LB = LB + section
				elif j == 2: # This corresponds with the mux.ino code
					RB = RB + section
				elif j == 3: # This corresponds with the mux.ino code
					LF = LF + section
				else: # This corresponds with the mux.ino code
					RF = RF + section
		addToFile(finalPath, LB, 1)
		addToFile(finalPath, RB, 0)
		addToFile(finalPath, LF, 0)
		addToFile(finalPath, RF, 0)

def addToFile(finalPath, listOfItems, isOverwrite):
	writeType = ['a','w']
	with open(finalPath, writeType[isOverwrite], newline='') as f:
		filewriter = writer(f, delimiter=',')
		filewriter.writerow(listOfItems)

def main(fileNames, properNames, fileDir, finalDir):
	if len(fileNames) == len(properNames):
		for i in range(len(fileNames)):
			filePath = join(fileDir, fileNames[i])
			finalPath =  join(finalDir, properNames[i] + ".csv")
			transposeFile(filePath, finalPath, 1)
			keepSecond(finalPath)
			splitData(finalPath)
			transposeFile(filePath, finalPath, 0)
			print("{0} rewritten to {1}".format(filePath,finalPath))
	else:
		print("Number of new file names do not match number of original file names.")

# The three variables below need to be manually set
properNames = ["BC_A",
			   "BR",
			   "BP_1",
			   "BP_2",
			   "BP_3",
			   "WC_L",
			   "BP_N",
			   "WC_R",
			   "WC_S",]
fileDir = "C:\\Users\\Fusion\\Desktop\\Raw_Data\\"
finalDir = "C:\\Users\\Fusion\\Desktop\\Raw_Data_edited\\"

main(listdir(fileDir), properNames, fileDir, finalDir)

