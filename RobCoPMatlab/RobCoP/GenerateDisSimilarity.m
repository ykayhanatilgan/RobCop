function O = GenerateDisSimilarity(I)
% This function is used for generating dissimilarity metric from given data
% matrix. The given data set is also standardized before generating the
% dissimilarities. The function implements 'LS', and 'Median' type
% standardizations; and 'Euclidean', 'Cityblock', and 'Dominance' type
% distance functions for generating dissimilarities.
%
% Explanation of input structure, I
% I.DataMatrix    : Data matrix from which the dissimilarities will be
%                   generated. Each column of the matrix corresponds to a
%                   variable while each row of the matrix corresponds to a
%                   data point.
% I.StdType       : Determines which data standardization technique will be
%                   used. 'Mean' uses mean and standard deviation, 'Median'
%                   uses median for mean, and MADN for scale.
% I.DisSimDist    : Selects distance function to be used for finding the
%                   dissimilarity metrics. Possible values are 'Euclidean',
%                   'Cityblock' and 'Dominance'.
%
% Explanation of output structure, O
% O.DisSimilarityMatrix : Generated dissimilarity matrix according to the
%                         selected standardization and distance function.
% O.StandardData        : Standardized data matrix.

% standardize the data matrix
if strcmp(I.StdType,'Mean')
    DataMean = mean(I.DataMatrix);
    DataMean = repmat(DataMean,size(I.DataMatrix,1),1);
    DataStd = std(I.DataMatrix);
    DataStd = repmat(DataStd,size(I.DataMatrix,1),1);
elseif strcmp(I.StdType,'Median')
    DataMean = median(I.DataMatrix);
    DataMean = repmat(DataMean,size(I.DataMatrix,1),1);
    DataStd = 1.4826*median(abs(I.DataMatrix-DataMean));
    DataStd = repmat(DataStd,size(I.DataMatrix,1),1);
else
    ErrMsg('GenerateDisSimilarity:StdType');
end
StandardData = (I.DataMatrix-DataMean)./DataStd;
% initialize dissimilarity matrix
DisSimilarityMatrix = zeros(size(I.DataMatrix,1),size(I.DataMatrix,1));
% generate dissimilarity matrix
for mRow = 1:size(I.DataMatrix,1)-1
    for nRow = mRow+1:size(I.DataMatrix,1)
        if strcmp(I.DisSimDist,'Euclidean')
            DisSimilarityMatrix(mRow,nRow) = sqrt(sum((StandardData(mRow,:)-StandardData(nRow,:)).^2));
            DisSimilarityMatrix(nRow,mRow) = DisSimilarityMatrix(mRow,nRow);
        elseif strcmp(I.DisSimDist,'Cityblock')
            DisSimilarityMatrix(mRow,nRow) = sum(abs(StandardData(mRow,:)-StandardData(nRow,:)));
            DisSimilarityMatrix(nRow,mRow) = DisSimilarityMatrix(mRow,nRow);
        elseif strcmp(I.DisSimDist,'Dominance')
            DisSimilarityMatrix(mRow,nRow) = max(abs(StandardData(mRow,:)-StandardData(nRow,:)));
            DisSimilarityMatrix(nRow,mRow) = DisSimilarityMatrix(mRow,nRow);
        else
            ErrMsg('GenerateDisSimilarity:DisSimDist');
        end
    end
end
%% output structure
O.DisSimilarityMatrix = DisSimilarityMatrix;
O.StandardData = StandardData;