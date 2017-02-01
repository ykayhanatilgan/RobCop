function O = ProcessFile(I)
% This function parses the input data file; and finds variable names , and
% generated data matrix.
%
% Explanation of input structure, I
% I.X             : Input data to be analyzed by Robust CoPlot. Input data
%                   can be a text file, which contains a data set while the
%                   first line should contain comma separated variable
%                   names.
%
% Explanation of output structure, O
% O.VarNames     : Variable names extracted from the first line of the data
%                  file. The first line of the data file should be comma
%                  separated variable names.
% O.DataMatrix   : Generated data matrix from the given data file.

%% file parsing
% open data file
FileId = fopen(I.X);
% read the first line for variable names
FirstLine = fgetl(FileId);
% variable names should be ',' seperated
VarNames = strsplit(FirstLine,',');
NumOfVariables = size(VarNames,2);
% close data file
fclose(FileId);
% read data file
DataMatrix = csvread(I.X,1);
% check the first line of the data file
if NumOfVariables < 3 || NumOfVariables ~= size(DataMatrix,2)
    ErrMsg('ProcessFile:NumOfVariables');
end
%% output structure
O.VarNames = VarNames;
O.DataMatrix = DataMatrix;