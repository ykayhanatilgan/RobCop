function DrawMDS(I)
% This function plots MDS graph, and adds variables vectors on it.
%
% Explanation of input structure, I
% I.Embedding    : The embedding obtained from MDS algorithm. This field
%                  gives the coordinates of the data points.
% I.MDSMethod    : The name of the MDS method used. This value will be used
%                  in the title of the plot.
% I.StdType      : Determines which data standardization technique will be
%                  used. This value will be used in the title of the plot.
% I.StressValue  : Stress value of the embedding that will be plotted. This
%                  value will be used in the title of the plot.
% I.ColorColumn  : The column from the data set which will be used in the
%                  coloring of the data points on the 2-D Robust CoPlot
%                  graph. If this field is given, I.ColorValues field
%                  should be specified. 
% I.ColorValues  : If I.ColorColumn is given, this field should be given.
%                  The coloring of the data points is performed according
%                  to the values given in this field. The values indicated
%                  by this field is used for selecting the data points by
%                  using I.ColorColumn-th column of the data set. 
% I.DrawGraph    : Selects graphs that will be plotted. Possible graph
%                  options are 'MDS', 'CoPlot', and 'ALL'. If this field is
%                  not defined or takes value other than the possible ones,
%                  no graph is plotted. 

%% check input
% check DrawGraph
DrawMDSGraph = 0;
if isfield(I,'DrawGraph')
    if strcmp(I.DrawGraph,'MDS') || strcmp(I.DrawGraph,'CoPlot') || strcmp(I.DrawGraph,'ALL')
        DrawMDSGraph = 1;
    end
end
% if MDS graph is wanted, check coloring
ColoredMDS = 0;
if DrawMDSGraph == 1
    % check coloring
    if isfield(I,'ColorColumn') && isfield(I,'ColorValues')
        ColoredMDS = 1;
    end
end
%% MDS plot
if DrawMDSGraph == 1 && ColoredMDS == 0
    figure;
    plot(I.Embedding(:,1),I.Embedding(:,2),'.')
    text(I.Embedding(:,1),I.Embedding(:,2),num2str([1:size(I.Embedding,1)]'));
elseif DrawMDSGraph == 1 && ColoredMDS == 1
    figure;
    PlottedIdx = [];
    % plot can be colored upto 6 different values
    if length(I.ColorValues) > 6
        warning('DrawMDS:ColorValues First 6 values of ColorValues are used.');
    end
    for mClr=1:min(6,length(I.ColorValues))
        if mClr == 1 % circle
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'ro','LineWidth',2,'MarkerSize',5)
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        if mClr == 2 % x-mark
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'kx','LineWidth',2,'MarkerSize',8)
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        if mClr == 3 % plus
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'b+','LineWidth',2)
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        if mClr == 4 % star
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'k*')
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        if mClr == 5 % square
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'ms','LineWidth',2)
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        if mClr == 6 % diamond
            Idx = find(I.ColorColumn == I.ColorValues(mClr));
            plot(I.Embedding(Idx,1),I.Embedding(Idx,2),'bd','LineWidth',2)
            text(I.Embedding(Idx,1),I.Embedding(Idx,2),num2str(Idx));
            hold on;
        end
        PlottedIdx = [PlottedIdx;Idx];
    end
    UnplottedIdx = setdiff((1:size(I.Embedding,1))',PlottedIdx);
    if ~isempty(UnplottedIdx)
        plot(I.Embedding(UnplottedIdx,1),I.Embedding(UnplottedIdx,2),'k.')
        text(I.Embedding(UnplottedIdx,1),I.Embedding(UnplottedIdx,2),num2str(UnplottedIdx));
    end
end
%% add title to plot
if DrawMDSGraph == 1
    TitleText = [I.MDSMethod '/' I.StdType ...
        ' (\sigma=' num2str(I.StressValue) ')'];
    title(TitleText,'FontSize',10);
end