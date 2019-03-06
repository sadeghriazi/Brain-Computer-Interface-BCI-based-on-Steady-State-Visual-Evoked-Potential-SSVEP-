# Brain Computer Interface (BCI) based on Steady State Visual Evoked Potential (SSVEP)


Instructions on how to use this system

1. Download and unzip all files in “Codes” section.

2. Put the Emotiv device on your head and turn it on.

3. Run GUI at: GUI_OpenGl\ by compiling Stimulator_opengl.cpp

4. In BCI2000 package: run batch\FieldTripBuffer_Emotiv.bat with parameters: parms\Emotive_parameteres.prm

5. Turn on your Bluetooth device** and run Android app on it

6. Run Digital_Signal_Processing_MATLAB\onlinify.m (set “Bluetooth_enable” flag variable to 1, if you are connecting to your Bluetooth device for the first time)


* You should have installed MATLAB, “Emotiv EEG 14 channels” device’s driver prior to use this system.

** Bluetooth device means the device you are using to be connected to MATLAB via Bluetooth and call the phone number processed and acquired by MATLAB.




Introduction

This project was as my B.Sc. project. The aim of this project is to implement a SSVEP (Steady State Visual Evoked Potentials) based BCI (Brain Computer Interface) which has the following application. There is a visual phone keypad displayed on the monitor and the user tries to dial that number only by looking at the numbers sequentially. The user should put a cap on his/her head which has some (in our case 14) different sensors to acquire his/her brain signals. User can dial the number that he wants by looking at the first digit of the number on the screen. Whenever that digit is showed on the screen (system also spells that number), user will look at the next digit of the number and so on. If the system gets the wrong digit, user should look at the “Backspace” button. By the time the maximum number of digits is reached or when the user has looked to “Call” button, system will dial that number using phone carrier service provider. This is how the system can be used. Bellow is the technical information and detail of how this system actually works and the end there are source codes and complete softwares which is needed to run this system using “Emotiv EEG 14 channels” device.




Background

BCI in general refers to any connection between the brain of human and any electronic device which usually are computers. There are several kind of brain activities which can be used like MTB, p300, SSVEP, etc. In this project we used SSVEP. In few sentences, SSVEP is kind of brain response when eyes are looking at oscillating light source; so when a person looks at the screen which is oscillating with frequency of “f”, the energy of brain signals at that frequency will increase and by analyzing the brain signals we can identify which frequency was that and so this is the physical context behind the system.



Description

We used “Emotiv EEG 14 Channel Device” but according to our testing we used only channels O1, O2, T7 and T8 for faster signal processing and better results. Signal is acquired by Emotiv cap and data is transferred into the computer and is handled by BCI 2000 which is a well known application in BCI scientific society. Field Trip Buffer is used to pass online data in 1 second blocks into MATLAB. When data arrives, the system will apply some filters such as 5Hz-30Hz band pass filter (to eliminate DC components and high frequency components which are not useful) and CMA filter (Common Mode Average Filter) for eliminating Mechanical noise due to relative vibration between the head and the cap. We then subtract the total signal average from the four major channels we used for processing. When the data passes through some primary filters we will begin processing using Minimum Energy Combination method [1] in order to reduce the influence of noise to the minimum possible level.

In addition, we used “Dynamic Window Size” to increase both accuracy and time efficiency. This is done as follows: when the system starts, 1sec block of data is passed to MATLAB and it will be processed. If the result passes the dedicated pre-defined threshold, the classifier will report the result but if not, it will wait until new data arrives and it will concatenate on the new block with previous ones and then press again. As before, if the result passes the threshold, it will report it. Otherwise, it will wait for the next data. When this time window of data reaches its maximum value, then the window will eliminate the first one and the size of window will remain constant until the reliable classification happens. This approach will give us flexibility and reliability since if the user suddenly decides to look off the screen; the system will not use the corresponding data, since the window is moving in time. When all of the required numbers are complete or the user looks at “Call” button, the digits will be sending via Bluetooth to an Android OS and the destination program will get these numbers and will establish a call connection.




Graphic Interface

Graphical interface is designed using “OpenGL” which is a frame-based language and is very suitable for flickering the screen based on every refresh of the (LCD) screen. Buttons are flickering at specific frequencies, 6Hz, 8Hz, 10Hz, 11Hz, 13Hz, 14Hz, 15Hz, 17Hz, 19Hz, 20Hz, 21Hz and 23Hz. The 12Hz and 16HZ are skipped due to the second harmonic of 6Hz and 8Hz frequencies respectively.
