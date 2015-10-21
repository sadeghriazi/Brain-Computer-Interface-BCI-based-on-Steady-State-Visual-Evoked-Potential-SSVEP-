function userSettings = onlinifyOptions()
% If you want any option to be set to its default value, simply ddo not
% include it in userSettings (comment that line)

userSettings = struct();
userSettings.fileReplay = 1;                % Do you want to read from a BCI2000 Data file instead of Fieldtrip
userSettings.processingBlockSec = 1;       % Length of the signal blocks given to processSignal (in seconds)
userSettings.dataFolderPath = 'C:\SSVEP_datas\Masih_Pack\7.1.92\doubles\masih12_10\masih001';        % The folder where the below address starts from
userSettings.dataFile = '\masihS001R01.dat'; % The path to the BCI2000 dat file you want to read from
userSettings.showResultsBox = 0;          % Enable/Disable the all results' strip
% userSettings.showEachOutput = 0;          % Enable/Disable the latest result box
% userSettings.samplingRate = 128;          % Sampling rate of the device (only needed in Fieldtrip mode)
% userSettings.numOfChannels = 14;          % Number of channels recorded by the device (only needed in Fieldtrip mode)
end

