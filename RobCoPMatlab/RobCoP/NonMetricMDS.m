function O = NonMetricMDS(I)
% Non-Metric Multidimensional scaling by using MATLAB built-in function
% mdscale().
%
% Explanation of input structure, I
% I.DisSimilarityMatrix : Dissimilarity matrix that will be used as guide
%                         while placing the data points onto 2-D space.
% I.InitMethod          : Selects initialization method for algorithm.
%                         Possible choices are 'Random', and 'PCA'.
% I.MDSDim              : Dimension of the resultant embedding which will
%                         be obtained by MDS.
% I.DrawGraph           : Controls plotting of Shepard Diagram.
%
% Explanation of output structure, O
% O.Embedding     : Obtained embedding of the data points.
% O.StressValue   : Stress value of the resultant embedding.
% O.Disparities   : Monotonic transformation of the dissimilarities.

%% find initial embedding according to given I.InitMethod
NumOfPoints = size(I.DisSimilarityMatrix,1);
if strcmp(I.InitMethod,'Random')
    % create a random initial embedding from normal distribution with
    % standard deviation 10, mean 0.
    X = 10*randn(NumOfPoints,I.MDSDim);
elseif strcmp(I.InitMethod,'PCA')
    % initialize by Principal Component Analysis
    X = mdscale(I.DisSimilarityMatrix,I.MDSDim,'Criterion','strain');
else
    ErrMsg('NonMetricMDSwithSMACOF:InitMethod');
end
%% find embedding of the data points
Options = statset('MaxIter',500);
[X,KruskalStress1,Disparities] = ...
    mdscale(I.DisSimilarityMatrix,I.MDSDim,'Start',X,'Options',Options);
%% Shepard Diagram
if isfield(I,'DrawGraph')
    if strcmp(I.DrawGraph,'Shepard') || strcmp(I.DrawGraph,'ALL')
        figure;
        plot(squareform(I.DisSimilarityMatrix),pdist(X,'euclidean'),...
            'k.','MarkerSize',10);
        grid on;hold on;
        [~,Order] = sortrows([Disparities(:) I.DisSimilarityMatrix(:)]);
        plot(I.DisSimilarityMatrix(Order),Disparities(Order),...
            'r','LineWidth',2);
        title('Shepard Diagram (NMDS)');
        xlabel('Dissimilarity');
        ylabel('Distance/Disparity');
    end
end
%% output structure
O.Embedding = X;
O.StressValue = KruskalStress1;
O.Disparities = Disparities;