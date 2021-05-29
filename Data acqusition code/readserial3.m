%% README
% 
% FILE: readserial3.m
%
% PURPOSE: reads arduino serial using C-based file io functions (fastest
% for continuous acqusition)
%
% To use this code, adjust the values under "variables" below as needed.
% Then, turn on your car and run the code. Click cancel on the popup when
% you have enough datapoints.

%% CODE
clear; clc; 

% variables
baudrate = 38400;
comport = "COM9";
labels = "Time,ENB,R_Speed,ENA,L_Speed";
filename = './raw/testfileio';

% initialize serial connection and baud rate
device = serialport(comport, baudrate);

% initialize the excelsheet
writematrix(strsplit(labels,','),[filename '.csv'],'writemode', 'overwrite')

% create a GUI stopbutton*
hWaitbar = waitbar(0, 'Iteration', 'Name', 'Acquiring data','CreateCancelBtn','delete(gcbf)');

iter = 1;
tic

% DAQ infinite loop
while true
    
    % read the output string
    serialdata = readline(device)
    toc

    % write to csv
    fileID = fopen([filename '.csv'], 'a');
    fprintf(fileID,'%s',serialdata);
    fclose(fileID);

    % GUI stopbutton break
    if ~ishandle(hWaitbar)
        disp('Stopped by user');
        break;
    else
        waitbar(iter,hWaitbar, ['Iteration ' num2str(iter)]);
    end
    
    iter = iter + 1;
end

% close the serial connection
clear device

% *NOTE: why do we need a GUI stop button?
%   It allows us to exit the script gracefully. If you CTRL+C, the script
%   stops immediately and doesn't run 'clear device' at the end, which 
%   makes MATLAB hold control of the serial port. If that happens, you
%   can't use the serial port until you unplug the device or manually type 
%   'clear device' in the MATLAB command window.