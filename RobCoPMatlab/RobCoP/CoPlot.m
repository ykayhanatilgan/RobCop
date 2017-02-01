function CoPlot(I)
% This function draws variable vectors onto MDS plot. It is assumed that an
% MDS graph is plotted before calling this function. After all, CoPlot is
% just a vector addition to the MDS plot. Hence, without MDS graph, drawing
% variable vectors is not meaningful.
%
% Explanation of input structure, I
% I.Embedding     : The embedding obtained from MDS algorithm. This field
%                   gives the coordinates of the data points.
% I.MDSMethod     : The name of the MDS method used. This value will be
%                   used in the title of the plot.
% I.StdType       : Determines which data standardization technique will be
%                   used. This value will be used in the title of the plot.
% I.StressValue   : Stress value of the embedding that will be plotted.
%                   This value will be used in the title of the plot. 
% I.DrawGraph     : Selects graphs that will be plotted. Possible graph
%                   options are 'CoPlot', and 'ALL'. If this field is not
%                   defined or takes value other than the possible ones, 
%                   no graph is plotted. 
% I.VecCorrMethod : If I.DrawGraph is given as 'CoPlot' or 'ALL', vector
%                   correlation method should also be given for drawing
%                   variable vectors on MDS plot. Possible values are 'PCC'
%                   for Pearson correlation, and 'MADCC' for Median
%                   Absolute Deviation correlation. 
% I.StandardData  : Standardized data that is used for finding the
%                   embedding of the data set. This data is also used for
%                   finding the best vector representation in CoPlot. The
%                   selected correlation method by I.VecCorr will be used
%                   for measuring vector representation quality.
% I.VarNames      : Variable names to be shown on the vector
%                   representation. The names are found from the first line
%                   of the data file.

%% check input
% check DrawGraph
DrawCoPlot = 0;
if isfield(I,'DrawGraph')
    if strcmp(I.DrawGraph,'CoPlot') || strcmp(I.DrawGraph,'ALL')
        DrawCoPlot = 1;
    end
end
%% CoPlot
if DrawCoPlot == 1
    % hold the MDS graph drawn previously
    hold on;
    % scale axis to see real vector representation
    axis equal
    % for scaled vector graph, length of the vectors are found by using
    % current MDS plot.
    MaxVecNorm = min([abs(xlim) abs(ylim)])*2;
    % for each variable, find vector representation
    for mVar = 1:size(I.StandardData,2)
        % init MaxCorrCoeff
        MaxCorrCoeff = -1;
        % search best vector representation by rotating
        for mTheta=0:2*pi/360:2*pi-2*pi/360
            % rotate clockwise by mTheta radian and take x-component
            XTheta = I.Embedding*[cos(mTheta);sin(mTheta)];
            if strcmp(I.VecCorrMethod,'MADCC')
                % MAD corr coefficient is being calculated
                u = (XTheta-median(XTheta))/(1.4826*median(abs(XTheta-median(XTheta))))+...
                    (I.StandardData(:,mVar)-median(I.StandardData(:,mVar)))/...
                    (1.4826*median(abs(I.StandardData(:,mVar)-median(I.StandardData(:,mVar)))));
                v = (XTheta-median(XTheta))/(1.4826*median(abs(XTheta-median(XTheta))))-...
                    (I.StandardData(:,mVar)-median(I.StandardData(:,mVar)))/...
                    (1.4826*median(abs(I.StandardData(:,mVar)-median(I.StandardData(:,mVar)))));
                CorrCoeff = ((median(abs(u-median(u))))^2-(median(abs(v-median(v))))^2)/...
                    ((median(abs(u-median(u))))^2+(median(abs(v-median(v))))^2);
                if CorrCoeff > MaxCorrCoeff
                    MaxCorrCoeff = CorrCoeff;
                    MaxTheta = mTheta;
                end
            elseif strcmp(I.VecCorrMethod,'PCC')
                % Pearson corr coefficient is being calculated
                CorrCoeff = (I.StandardData(:,mVar)-mean(I.StandardData(:,mVar)))'*(XTheta-mean(XTheta))/...
                    (sqrt(sum((I.StandardData(:,mVar)-mean(I.StandardData(:,mVar))).^2))*sqrt(sum((XTheta-mean(XTheta)).^2)));
                if CorrCoeff > MaxCorrCoeff
                    MaxCorrCoeff = CorrCoeff;
                    MaxTheta = mTheta;
                end
            else
                ErrMsg('CoPlot:VecCorrMethod');
            end
        end
        % x and y coordinates of the vector
        VecX=[cos(MaxTheta) -sin(MaxTheta)]*[MaxCorrCoeff*MaxVecNorm;0];
        VecY=[sin(MaxTheta) cos(MaxTheta)]*[MaxCorrCoeff*MaxVecNorm;0];
        plot([0 VecX],[0 VecY],'k','LineWidth',2);
        % write variable names and correlation coefficients
        text(VecX,VecY,[I.VarNames{1,mVar} '(' num2str(MaxCorrCoeff) ')'],'FontSize',10);
    end
    % update title of figure
    TitleText = ['CoPlot ' I.MDSMethod '/' I.StdType ' ' I.VecCorrMethod ...
        ' (\sigma=' num2str(I.StressValue) ')'];
    title(TitleText,'FontSize',10);
end