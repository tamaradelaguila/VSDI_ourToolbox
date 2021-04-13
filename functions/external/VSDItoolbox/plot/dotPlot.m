function dotPlot(dWT,dEXP,labelWT,labelEXP,axH,YLim)

if nargin<5,
    figure
    axH=gca;
end
if nargin<6,
    YLim = [min([min(dWT) min(dEXP)]) max([max(dWT) max(dEXP)]) ]; % set y limits based on the range of the data
    YLimRange = YLim(2)-YLim(1);
    YLim(1) = YLim(1) - 0.05*YLimRange; % nudge the limit wider
    YLim(2) = YLim(2) + 0.05*YLimRange; % nudge the limit wider
end


axes(axH)
plot([.5 2.5],[0 0],'k:') % plot dotted line to show X axis
hold on

% plot(ones(size(dWT)),dWT,'.k') % plot WT data
% plot(ones(size(dEXP))*2,dEXP,'.r') % plot EXP data

% plot mean and STD for WT dots
plotMeanWT = mean(dWT); plotStdWT = std(dWT);
plot([1-.35 1+.35],[plotMeanWT plotMeanWT],'Color',[.5 .5 .5],'LineWidth',1) % plot the mean value as a thick line
plot([1-.2 1+.2],[plotMeanWT-plotStdWT plotMeanWT-plotStdWT],':','Color',[.5 .5 .5],'LineWidth',1) % plot the mean value as a thick line
plot([1-.2 1+.2],[plotMeanWT+plotStdWT plotMeanWT+plotStdWT],':','Color',[.5 .5 .5],'LineWidth',1) % plot the mean value as a thick line

% plot mean and STD for EXP dots
% plot mean and STD for WT dots
plotMeanEXP = mean(dEXP); plotStdEXP = std(dEXP);
plot([2-.35 2+.35],[plotMeanEXP plotMeanEXP],'Color',[1 .3 .3],'LineWidth',1) % plot the mean value as a thick line
plot([2-.2 2+.2],[plotMeanEXP-plotStdEXP plotMeanEXP-plotStdEXP],':','Color',[1 .3 .3],'LineWidth',1) % plot the mean value as a thick line
plot([2-.2 2+.2],[plotMeanEXP+plotStdEXP plotMeanEXP+plotStdEXP],':','Color',[1 .3 .3],'LineWidth',1) % plot the mean value as a thick line

[xWT,yWT]=dotPlotCoords(dWT,YLim);
[xEXP,yEXP]=dotPlotCoords(dEXP,YLim);

plot(xWT+1,yWT,'.k') % plot WT data
plot(xEXP+2,yEXP,'.r') % plot EXP data

hold off
set(axH,'FontSize',6,'XTick',[1 2],'XTickLabel',{labelWT; labelEXP})

set(axH,'XLim',[.5 2.5])
set(axH,'YLim',YLim)
box off



function [x,y] = dotPlotCoords(ptsIn,YLim)

CLOSENESS_LIMIT_PERCENT = 3;
X_DIST_CLUSTERS = 0.15;

ptsIn = sort(ptsIn); % first, sort the list

%rangePtsIn = max(ptsIn)-min(ptsIn); % range is used to determine roughly how tall the graph will be.  this impacts how much space there is between spots
rangePtsIn = abs(YLim(1)-YLim(2)); % range is used to determine roughly how tall the graph will be.  this impacts how much space there is between spots

dTooClose = rangePtsIn*CLOSENESS_LIMIT_PERCENT/100; % if two spots are within a distance equal to 5 percent of the range, we'll nudge them into multiple columns

distPts = diff(ptsIn); % measure the distance between each point and it's neighbor
ptsTooClose = distPts<dTooClose; % binary vector describing points that are within the tolerance

% now it gets tricky.  if the points are too close to each other, scatter
% them horizontally
x=zeros(size(ptsIn)); % preallocate
ind=2; % for indexing ptsTooClose and X
onList=1;
while onList,
    if ptsTooClose(ind-1),
        nextZero = find(ptsTooClose(ind:end)==0,1,'first'); % find the next point that is far enough away that we won't have to scatter dots horizontally
        if isempty(nextZero),
            nextZero = length(ptsTooClose(ind:end))+1; % if we're at the end of the list, pretend there's a zero off the end of the list
        end
        numPtsInCluster = nextZero+1; % the number of points is always 2 or more
        x(ind-1:ind-1+numPtsInCluster-1) = (0:numPtsInCluster-1) * X_DIST_CLUSTERS - ((numPtsInCluster-1)*X_DIST_CLUSTERS/2); % define x values for the points in the cluster, to scatter them horizontally
        ind=ind+numPtsInCluster; % increment to the next point outside of the cluster
    else
        
    ind=ind+1; % if the current point isn't too close to the next point, keep moving along
    end
    if ind>length(x),onList=0;end % when we get to the end of the list, we're done
end
y=ptsIn;