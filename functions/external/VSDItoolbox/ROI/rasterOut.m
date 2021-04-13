function rasterOut(img,frameInterval_ms,pixWidth_mm,grayLineLoc,fig,fname)
% IMG is raster data
% FRAMEINTERVAL_MS is the number of milliseconds per frame (x axis)
% PIXWIDTH_MM is the real-world width of the region that is averaged to obtain each pixel row (in mm)
% GRAYLINELOC is the indices of gray partition lines in the image(if any)
% FIG is a figure number or figure handle
% FNAME is the name of the file to save, without file extension

if nargin==5, % if no fname is specified, make fname an empty array
    fname=[];
end

figure(fig),set(gcf,'Name',fname,'Position',[807 408 640 160],'PaperPositionMode','auto')

t = 0:frameInterval_ms:(size(img,2)*frameInterval_ms-frameInterval_ms);

% make a y label list
yDist = ones(size(img,1)+length(unique(grayLineLoc)),1);
yDist(grayLineLoc) = 0; % yDist now has ones for every row that contains data and zeros for every row that is grayed out
yDist = cumsum(yDist); % cumulative sum of the binary vector - will multiply by the step between each pixel to get to real world distances
yDist = yDist*pixWidth_mm; % convert to real world distances

% create Y axis labels using the values in YDIST
Ytick = [];
YtickLabel= [];
found=find(yDist>0,1); % find the first nonzero y value
i=1;
while ~isempty(found), % march up the Y axis and find indices corresponding to 1 mm increments (this is necessary because some Y pixels correspond to spacer rows)
    Ytick=[Ytick found];
    YtickLabel=[YtickLabel i-1];
    found=find(yDist>i,1); % find the yDist position that corresponds to the next 1 mm increment
    i=i+1;
end
Ytick=Ytick-1;

image(t,[],img) % plot the image with x and y labels
ylabel('arc position (mm)')
xlabel('time (ms)')
set(gca,'YDir','normal') % puts the dentate at the bottom of the plot
box off

%Ytick
%YtickLabel
set(gca,'YTick',Ytick,'YTickLabel',YtickLabel')

if ~isempty(fname),
    print(fig, '-dtiff','-opengl',[fname '.tif'])  % output the image
end
