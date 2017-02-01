%% NOTE
% This m-file is prepared as example of RobCoP package usage. The following
% sections can be used to reproduce figures used in manuscript entitled by
% "RobCoP: A MATLAB Package for Robust CoPlot Analysis" and published by
% Open Journal of Statistics. Further information can be found by
% referencing the manuscript.
%
% http://www.scirp.org/journal/ojs/
%
%% NMDS example (Figure 2 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'NMDS';           % non-metric MDS
InStrct.DrawGraph = 'MDS';            % MDS graph
OutStrct = RobustCoPlot(InStrct)     % run analysis
%% NMDS example (Figure 4 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'NMDS';           % non-metric MDS
InStrct.DrawGraph = 'Shepard';       % Shephard graph
OutStrct = RobustCoPlot(InStrct)     % run analysis
%% RMDS example (Figure 3 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'RMDS';           % robust MDS
InStrct.OutlierRatio = 0.1;          % 10% outlier ratio
InStrct.DrawGraph = 'MDS';            % MDS graph
OutStrct = RobustCoPlot(InStrct)     % run analysis
%% RMDS example (Figure 5 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'RMDS';           % robust MDS
InStrct.OutlierRatio = 0.1;          % 10% outlier ratio
InStrct.DrawGraph = 'Shepard';       % Shephard graph
OutStrct = RobustCoPlot(InStrct)     % run analysis
%% classical CoPlot (Figure 6 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'NMDS';           % non-metric MDS
InStrct.DrawGraph = 'CoPlot';         % CoPlot graph
InStrct.VecCorrMethod = 'PCC';        % Pearson correlation
OutStrct = RobustCoPlot(InStrct);    % run analysis
%% robust CoPlot (Figure 7 of the paper)
% move cursor ON THIS LINE and press Ctrl+Enter
clear all;
close all;
clc;

InStrct.X = 'ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Median';           % median-MAD standardization
InStrct.MDSMethod = 'RMDS';           % robust MDS
InStrct.OutlierRatio = 0.1;          % 10% outlier ratio
InStrct.DrawGraph = 'CoPlot';         % CoPlot graph
InStrct.VecCorrMethod = 'MADCC';      % MAD correlation
OutStrct = RobustCoPlot(InStrct);    % run analysis