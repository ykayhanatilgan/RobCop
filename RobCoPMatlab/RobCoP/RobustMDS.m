function O = RobustMDS(I)
% Robust Multidimensional scaling algorithm proposed by Forero, and
% Giannakis.
%
% References :
% Robust Multi-Dimensional Scaling via Outlier-Sparsity Control, Forero
% P.A., Giannakis G.B., ASILOMAR, 2011.
%
% Explanation of input structure, I
% I.DisSimilarityMatrix : Dissimilarity matrix that will be used as guide
%                         while placing the data points onto 2-D space.
% I.InitMethod          : Selects initialization method for algorithm.
%                         Possible choices are 'Random', and 'PCA'.
% I.MDSDim              : Dimension of the resultant embedding which will
%                         be obtained by MDS.
% I.OutlierRatio        : Minimum ratio of number of distances that are
%                         deemed as outlier while calculating the stress
%                         value of the MDS representation.
% I.DrawGraph           : Controls plotting of Shepard Diagram.
%
% Explanation of output structure, O
% O.Embedding     : Obtained embedding of the data points.
% O.StressValue   : Stress value of the resultant embedding.
% O.OutlierMatrix : Non-zero values of the matrix identifies the distances
%                   that are deemed as outlier.

% Note : variable notations are inherited from the reference of the
% algorithm. this makes the code traceable.

%% find initial embedding according to given I.InitMethod
NumOfPoints = size(I.DisSimilarityMatrix,1);
if strcmp(I.InitMethod,'Random')
    % create a random initial embedding from normal distribution with
    % standard deviation 10, mean 0.
    X = 10*randn(I.MDSDim,NumOfPoints);
elseif strcmp(I.InitMethod,'PCA')
    % initialize by Principal Component Analysis
    X = mdscale(I.DisSimilarityMatrix,2,'Criterion','strain');
    X = X';
else
    ErrMsg('RobustMDS:InitMethod');
end
%% check outlier ratio
if I.OutlierRatio < 0 || I.OutlierRatio >= 1
    ErrMsg('RobustMDS:OutlierRatio');
end
%% find embedding of the data points
% initialize distance matrix
dOfX = squareform(pdist(X','euclidean'));
% arrange grid max and min for lambda value
LambdaMax = 2*max(max(abs(I.DisSimilarityMatrix-dOfX)));
LambdaMin = 10^-4*LambdaMax;
% algorithm will find an embedding for each lambda value
L = NumOfPoints*eye(NumOfPoints)-ones(NumOfPoints,NumOfPoints);
LInv = pinv(L); % Moore-Penrose pseudoinverse
for lambda = logspace(log10(LambdaMax),log10(LambdaMin),1000)
    while(1)
        % update outlier matrix (eqn 20)
        OutlierMatrix = sign(I.DisSimilarityMatrix-dOfX).*...
            max(0,(abs(I.DisSimilarityMatrix-dOfX)-lambda/2));
        % update X (eqn 22)
        % define range for (n,m)
        P = (I.DisSimilarityMatrix>OutlierMatrix).*(dOfX>0);
        % eqn 11a
        A1 = P.*((I.DisSimilarityMatrix-OutlierMatrix)./dOfX);
        % divide by zero values assigned to zero
        A1(isnan(A1)) = 0;
        % eqn 12a
        L1 = diag(A1*ones(NumOfPoints,1))-A1;
        % eqn 22
        XUpdate = X*L1*LInv;
        % stop condition for selected lambda
        if norm(XUpdate-X,'fro')/norm(XUpdate,'fro')<10^-6
            X = XUpdate;
            dOfX = squareform(pdist(X','euclidean'));
            % outlier-free range
            Tg = (OutlierMatrix == 0);
            % number of outliers
            S = sum(sum(OutlierMatrix ~= 0))/2;
            OutlierFreeStress = sqrt(sum(sum(Tg.*(I.DisSimilarityMatrix-dOfX).^2))...
                /sum(sum(Tg.*I.DisSimilarityMatrix.^2)));
            break;
        end
        X = XUpdate;
        dOfX = squareform(pdist(X','euclidean'));
    end
    % stop condition for Robust MDS
    if S/(NumOfPoints*(NumOfPoints-1)/2) >= I.OutlierRatio
        break;
    end
end
% embedding of data points
X = X';
%% Shepard Diagram
if isfield(I,'DrawGraph')
    if strcmp(I.DrawGraph,'Shepard') || strcmp(I.DrawGraph,'ALL')
        figure;
        plot(squareform(I.DisSimilarityMatrix),pdist(X,'euclidean'),...
            'k.','MarkerSize',10);
        grid on;hold on;
        line([0 max(max(I.DisSimilarityMatrix))],...
            [0 max(max(I.DisSimilarityMatrix))],'Color','r','LineWidth',2);
        title('Shepard Diagram (RMDS)');
        xlabel('Dissimilarity');
        ylabel('Distance');
    end
end
%% output structure
O.Embedding = X;
O.StressValue = OutlierFreeStress;
O.OutlierMatrix = OutlierMatrix;