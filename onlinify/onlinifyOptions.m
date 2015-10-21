function userSettings = onlinifyOptions()
% If you want any option to be set to its default value, simply ddo not
% include it in userSettings (comment that line)

userSettings = struct();
userSettings.fileReplay = 0;                % Do you want to read from a BCI2000 Data file instead of Fieldtrip
userSettings.processingBlockSec = 60;       % Length of the signal blocks given to processSignal (in seconds)
userSettings.dataFolderPath = '..\';        % The folder where the below address starts from
userSettings.dataFile = 'P300\omid020\omidS020R04.dat'; % The path to the BCI2000 dat file you want to read from
% userSettings.showResultsBox = 1;          % Enable/Disable the all results' strip
% userSettings.showEachOutput = 0;          % Enable/Disable the latest result box
% userSettings.samplingRate = 128;          % Sampling rate of the device (only needed in Fieldtrip mode)
% userSettings.numOfChannels = 14;          % Number of channels recorded by the device (only needed in Fieldtrip mode)
end