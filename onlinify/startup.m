% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Online application based on BCI2000
% The startup and path preparation happens here
% by Omid Ghasemsani - omidsani@gmail.com
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set this to the path to your copy of BCI2000 (usualy 'C:\BCI2000')
BCI2000Path = 'C:\BCI2000'; 

% Set this to the path to your copy of FieldtripBuffer (usualy 'C:\Program Files\MATLAB\XXXXXX\toolbox\fieldtrip' in which XXXXXX indicates MATLAB version (such as R2009a))
FTBufferPath = 'C:\Program Files\MATLAB\fieldtrip-20140226'; 



% Initialize BCI2000 tools
olddir = pwd;
cd(BCI2000Path)     % The absolute path has to be hardcoded somewhere, and here it is.  Watch out, in case this is (or becomes) incorrect 
% cd('E:\BCI2000')   % The absolute path has to be hardcoded somewhere, and here it is.  Watch out, in case this is (or becomes) incorrect 
cd tools, cd matlab
bci2000path -AddToMatlabPath tools/matlab
bci2000path -AddToMatlabPath tools/mex
bci2000path -AddToSystemPath tools/cmdline   % required so that BCI2000CHAIN can call the command-line tools
cd(olddir) % change directory back to where we were before
clear olddir


% Initialize field trip buffer
addpath(FTBufferPath);
ft_defaults % initialize field trip