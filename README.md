# EMG-Exercise-Analysis

## Overview:

* Circuits and PCB for 4 channel EMG data acquisition
* Bluno beetle and Android app interfacing for wireless real-time transfer of data
* Machine learning and implemention of Random Forest Classifier for 9 exercises

## Current Project Functionalities:

1. Take EMG signals from 4 channels and pass them through the PCB to remove noise and amplify the signal

2. Transfer the data over Bluetooth to the Android app which receives and updates multiline graphs in real time.

3. Save the data on a local file or online database

4. Put the data through a random forest classifier for exercise classification of 9 different exercises

## Problems We Encountered:

* Low quality circuit boards are near impossible to work with
* Natural inconsistencies in the hardware leading to hours of debugging
* Lack of guides for using a multiplexer
* Training the random forest classifier

## To Do:

1. Attach the “nervous system” to the “skin”

2. Pass data through seglearn
	* Option 1: get seglearn working on a phone
	* Option 2: get the data off the phone and run seglearn on a computer

3. Improve machine learning and database handling

4. Test interfacing of the app and the Bluno Beetle instead of the app and Arduino for communication

## Maintainers:

* [Andrew Luo](https://github.com/Andrew-Luo1)
* [Earvin Tio](https://github.com/EarvinTio)
* [Jerry Liu](https://github.com/jerryliu3)
