function O = RobustCoPlot(I)
% Implements Robust CoPlot technique expanded on by "Robust Coplot
% Analysis", DOI:10.1080/03610918.2013.875571
%
% Explanation of input structure, I
% I.X             : Input data to be analyzed by Robust CoPlot. Input data
%                   can be a text file, which contains a data set while the
%                   first line should contain comma separated variable
%                   names.
% I.DataColNums   : Selects the data columns from the input file that are
%                   going to be used in the Robust CoPlot analysis.
% I.ColorColumn   : (Optional) Selects the column from the data set which
%                   will be used in the coloring of the data points on the
%                   2-D Robust CoPlot graph. If this field is given,
%                   I.ColorValues field should be specified.
% I.ColorValues   : If I.ColorColumn is given, this field should be given.
%                   The coloring of the data points is performed according
%                   to the values given in this field. The values indicated
%                   by this field is used for selecting the data points by
%                   using I.ColorColumn-th column of the data set. The MDS
%                   plot can be colorized upto 6 different values. The
%                   colors and shapes are assigned to the values in the
%                   order; red/o, black/x, blue/+, black/*, magenta/square,
%                   and blue/diamond.
% I.StdType       : Determines which data standardization technique will be
%                   used. 'Mean' uses mean and standard deviation, 'Median'
%                   uses median for mean, and MADN for scale.
% I.DisSimDist    : Selects distance function to be used for finding the
%                   dissimilarity metrics. Possible values are 'Euclidean',
%                   'Cityblock' and 'Dominance'. If I.FileType is given as
%                   'Data' this field should be specified.
% I.MDSMethod     : Selects type of the MDS representation of the data set
%                   given by txt file. Possible choices are 'RMDS' for
%                   Robust MDS and 'NMDS' for Non-Metric MDS.
% I.InitMethod    : Selects initialization method for MDS algorithm.
%                   Possible choices are 'Random', and 'PCA' for Principal
%                   Component Analysis.
% I.OutlierRatio  : If I.MDSMethod is given as 'RMDS', Minimum ratio of
%                   number of distances that are deemed as outlier while
%                   calculating the stress value of the MDS representation.
% I.DrawGraph     : Selects graphs that will be plotted. Possible graph
%                   options are 'Shepard', 'MDS', 'CoPlot', and 'ALL'. If
%                   this field is not defined or takes value other than the
%                   possible ones, no graph is plotted.
% I.VecCorrMethod : If I.DrawGraph is given as 'CoPlot' or 'ALL', vector
%                   correlation method should also be given for drawing
%                   variable vectors on MDS plot. Possible values are 'PCC'
%                   for Pearson correlation, and 'MADCC' for Median
%                   Absolute Deviation correlation.
%
% Explanation of output structure, O
% O.Embedding     : Obtained embedding of the data points.
% O.StressValue   : Stress value of the resultant embedding.
% O.OutlierMatrix : Non-zero values of the matrix identifies the distances
%                   that are deemed as outlier. (If 'RMDS' is selected.)
%
%
% Copyright <2016> <Yasemin Kayhan>
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met: 
%
% 1. Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


%% check input
if ~isstruct(I)
    ErrMsg('RobustCoPlot:Input');
end
if ~isfield(I,'X')
    ErrMsg('RobustCoPlot:X');
end
%%
% process input I.X
FileI.X = I.X;
FileO = ProcessFile(FileI);
% find number of variables
NumOfVariables = size(FileO.VarNames,2);
% the data columns that are going to be selected from the file should be
% specified
if ~isfield(I,'DataColNums')
    ErrMsg('RobustCoPlot:DataColNums');
end
if sum(I.DataColNums > NumOfVariables) ~= 0
    ErrMsg('RobustCoPlot:DataColNums');
end
% if given, select color column from the given data set.
if isfield(I,'ColorColumn')
    % just one column for coloring is allowed
    if length(I.ColorColumn) > 1
        ErrMsg('RobustCoPlot:ColorColumn');
    end
    if sum(I.ColorColumn > NumOfVariables) ~= 0
        ErrMsg('RobustCoPlot:ColorColumn');
    end
    % select color column from data set
    ColorColumn = FileO.DataMatrix(:,I.ColorColumn);
    % if ColorColumn is given, ColorValues should also be given
    if ~isfield(I,'ColorValues')
        ErrMsg('RobustCoPlot:ColorValues');
    end
    ColorValues = I.ColorValues;
end
% select data columns
DataMatrix = FileO.DataMatrix(:,I.DataColNums);
% select variable names of the selected data columns
VarNames = FileO.VarNames(I.DataColNums);
% check data standardization type
if ~isfield(I,'StdType')
    ErrMsg('RobustCoPlot:StdType');
end
% check dissimilarity distance type
if ~isfield(I,'DisSimDist')
    ErrMsg('RobustCoPlot:DisSimDist');
end
% generate DisSimilarityMatrix
DisSimI.DataMatrix = DataMatrix;
DisSimI.StdType = I.StdType;
DisSimI.DisSimDist = I.DisSimDist;
DisSimO = GenerateDisSimilarity(DisSimI);
%% find embedding of data set
if ~isfield(I,'MDSMethod')
    ErrMsg('RobustCoPlot:MDSMethod');
end
if ~isfield(I,'InitMethod')
    ErrMsg('RobustCoPlot:InitMethod');
end
% perform MDS
if strcmp(I.MDSMethod,'RMDS')
    % if RMDS is selected, OutlierRatio should also be given
    if ~isfield(I,'OutlierRatio')
        ErrMsg('RobustCoPlot:OutlierRatio');
    end
    % prepare RMDSI input structure
    RMDSI.DisSimilarityMatrix = DisSimO.DisSimilarityMatrix;
    RMDSI.InitMethod = I.InitMethod;
    RMDSI.MDSDim = 2; % 2-D embedding for CoPlot
    RMDSI.OutlierRatio = I.OutlierRatio;
    % check graph option
    if isfield(I,'DrawGraph')
        RMDSI.DrawGraph = I.DrawGraph;
    end
    MDSO = RobustMDS(RMDSI);
elseif strcmp(I.MDSMethod,'NMDS')
    % prepare NMDSI input structure
    NMDSI.DisSimilarityMatrix = DisSimO.DisSimilarityMatrix;
    NMDSI.InitMethod = I.InitMethod;
    NMDSI.MDSDim = 2; % 2-D embedding for CoPlot
    % check graph option
    if isfield(I,'DrawGraph')
        NMDSI.DrawGraph = I.DrawGraph;
    end
    MDSO = NonMetricMDS(NMDSI);
else
    ErrMsg('RobustCoPlot:MDSMethod');
end
%% plot MDS results
% prepare DrawMDSI structure
DrawMDSI.Embedding = MDSO.Embedding;
DrawMDSI.StressValue = MDSO.StressValue;
DrawMDSI.MDSMethod = I.MDSMethod;
DrawMDSI.StdType = I.StdType;
% check color option
if isfield(I,'ColorColumn')
    DrawMDSI.ColorColumn = ColorColumn;
    DrawMDSI.ColorValues = ColorValues;
end
% check graph option
if isfield(I,'DrawGraph')
    DrawMDSI.DrawGraph = I.DrawGraph;
end
% plotting MDS
DrawMDS(DrawMDSI);
%% plot CoPlot
% prepare CoPI structure
CoPI.Embedding = MDSO.Embedding;
CoPI.StressValue = MDSO.StressValue;
CoPI.MDSMethod = I.MDSMethod;
CoPI.StdType = I.StdType;
CoPI.StandardData = DisSimO.StandardData;
CoPI.VarNames = VarNames;
% check graph option
if isfield(I,'DrawGraph')
    CoPI.DrawGraph = I.DrawGraph;
    % if CoPlot is desired, check VecCorrMethod
    if strcmp(I.DrawGraph,'CoPlot') || strcmp(I.DrawGraph,'ALL')
        if ~isfield(I,'VecCorrMethod')
            ErrMsg('RobustCoPlot:VecCorrMethod');
        end
        CoPI.VecCorrMethod = I.VecCorrMethod;
    end
end
% plotting vectors
CoPlot(CoPI);
%% output sutructure
O.Embedding = MDSO.Embedding;
O.StressValue = MDSO.StressValue;
% if robust MDS is selected
if strcmp(I.MDSMethod,'RMDS')
    O.OutlierMatrix = MDSO.OutlierMatrix;
end