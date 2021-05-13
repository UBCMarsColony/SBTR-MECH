function SecondNichromeTest = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  SECONDNICHROMETEST = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  SECONDNICHROMETEST = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  SecondNichromeTest = importfile("C:\Users\andre\Downloads\Second Nichrome Test.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 03-May-2021 17:04:22

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Relay", "Time", "NichromeOutletTempC", "NichromeMidpointC", "NichromeInletTempC", "GasTempC"];
opts.VariableTypes = ["categorical", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Relay", "EmptyFieldRule", "auto");

% Import the data
SecondNichromeTest = readtable(filename, opts);

end