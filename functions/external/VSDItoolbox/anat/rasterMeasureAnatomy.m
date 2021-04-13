function [lenHil,lenCA3,lenCA1,areaHilRad,areaHilOr,areaCA3rad,areaCA3or,areaCA1rad,areaCA1or] = rasterMeasureAnatomy(polyInner,polyOuter,regionPolyCVL,regionLinesCVL,imBg,debug)
%
% example commands:
% rasterMeasureAnatomy(polyRadWT,polyOrWT,regionPolyCVLWT,regionLinesCVLWT,imBgWT,1)
% -or-
% rasterMeasureAnatomy(polyRadArxDlx,polyOrArxDlx,regionPolyCVLArxDlx,regionLinesCVLArxDlx,imBgArxDlx,1)
%
% !!!! WON'T WORK WITH VSDITOOLBOX !!!!!!
% !!!!!!!!!!!!!!!!!!!!!! commands for loading the data 
% !!!!!!!!!!!!!!!!!!!!!! [~,~,~,intLinePolyRadWT,intLinePolyOrWT,nMiceWT,nSlicesWT,regionPolyCVLWT,regionLinesCVLWT,polyRadWT,polyOrWT,imBgWT] = loadCsvRasters('wt_anatomy.csv','e:\data',0);
% !!!!!!!!!!!!!!!!!!!!!! [~,~,~,intLinePolyRadArxDlx,intLinePolyOrArxDlx,nMiceArxDlx,nSlicesArxDlx,regionPolyCVLArxDlx,regionLinesCVLArxDlx,polyRadArxDlx,polyOrArxDlx,imBgArxDlx] = loadCsvRasters('arxdlx_anatomy.csv','e:\data',0);

if nargin<6,
    debug=0;
end

userSettings; % we need the value GLO_VARS.pixLen to convert from pixel dimensions to real world (mm) dimensions

% For our purposes (analysis of CA morphology), polyInner is the radiatum 
% and polyOuter is the oriens.
polyRad = polyInner;
polyOr  = polyOuter;

lenHil = zeros(length(polyInner),1); % preallocate to store one value for each slice
lenCA3 = zeros(length(polyInner),1);
lenCA1 = zeros(length(polyInner),1);
areaHilRad = zeros(length(polyInner),1);
areaCA3rad = zeros(length(polyInner),1);
areaCA1rad = zeros(length(polyInner),1);
areaHilOr = zeros(length(polyInner),1);
areaCA3or = zeros(length(polyInner),1);
areaCA1or = zeros(length(polyInner),1);


for i=1:length(polyInner), % for each control slice
    if debug,
        figure(200+i)
        imagesc(imBg{i}),axis equal,axis off,colormap gray % plot the background image
        hold on
        
% %         % plot polygons
% %         for j=1:length(polyRad{i}),
% %             plot([polyRad{i}{j}(:,1); polyRad{i}{j}(1,1)],[polyRad{i}{j}(:,2); polyRad{i}{j}(1,2)],'k')
% %             plot([polyOr{i}{j}(:,1); polyOr{i}{j}(1,1)],[polyOr{i}{j}(:,2); polyOr{i}{j}(1,2)],'k')
% %         end
% %         
% %         % plot hand-drawn lines
% %         plot(regionLinesCVL{i}{1}(:,1),regionLinesCVL{i}{1}(:,2),'b')% plot the midline
% %         plot(regionLinesCVL{i}{2}(:,1),regionLinesCVL{i}{2}(:,2),'r')% plot hashPyrStart
% %         plot(regionLinesCVL{i}{3}(:,1),regionLinesCVL{i}{3}(:,2),'r')% plot hashCA2
% %         plot([regionPolyCVL{i}{1}(:,1); regionPolyCVL{i}{1}(1,1)],[regionPolyCVL{i}{1}(:,2); regionPolyCVL{i}{1}(1,2)],'g') % plot polyline
% %         
        hold off
        pause(0.1)
    end
    % first, for each slice, measure the length of the cell body layer in each region
    [lenHil(i),lenCA3(i),lenCA1(i)] = getRegionLengths(regionLinesCVL{i}{1},regionPolyCVL{i}{1},regionLinesCVL{i}{2},regionLinesCVL{i}{3}); % function below, for measuring lengths of hilus, CA3, and CA1
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    intLinePolyRad(1) = intLinePolyList(polyRad{i},regionLinesCVL{i}{2}); % find which boxes are intersected by the boundary lines
    intLinePolyRad(2) = intLinePolyList(polyRad{i},regionLinesCVL{i}{3});
    intLinePolyOr(1) = intLinePolyList(polyOr{i},regionLinesCVL{i}{2}); 
    intLinePolyOr(2) = intLinePolyList(polyOr{i},regionLinesCVL{i}{3});
    
    if intLinePolyRad(1) > intLinePolyRad(2), % if the first radiatum intersection line is located closer to the hilus, reverse the order of the two intersection lines for the radiatum
        intLinePolyRad = fliplr(intLinePolyRad);
    end
    
    if intLinePolyOr(1) > intLinePolyOr(2), % if the first oriens intersection line is located closer to the hilus, reverse the order of the two intersection lines for the oriens
        intLinePolyOr = fliplr(intLinePolyOr);
    end
    
    % compute the area of each anatomical region
    [areaHilRad(i),areaCA3rad(i),areaCA1rad(i)] = getRegionArea(polyRad{i},intLinePolyRad);
    [areaHilOr(i),areaCA3or(i),areaCA1or(i)] = getRegionArea(polyOr{i},intLinePolyOr);
    
end

% convert all values from pixel dimensions to real world dimensions (mm)
lenHil = lenHil*GLO_VARS.pixLen;
lenCA3 = lenCA3*GLO_VARS.pixLen;
lenCA1 = lenCA1*GLO_VARS.pixLen;
areaHilRad = areaHilRad*GLO_VARS.pixLen*GLO_VARS.pixLen; % for areas, multiply by the area of each pixel (GLO_VARS.pixLen^2)
areaHilOr = areaHilOr*GLO_VARS.pixLen*GLO_VARS.pixLen;
areaCA3rad = areaCA3rad*GLO_VARS.pixLen*GLO_VARS.pixLen;
areaCA3or = areaCA3or*GLO_VARS.pixLen*GLO_VARS.pixLen;
areaCA1rad = areaCA1rad*GLO_VARS.pixLen*GLO_VARS.pixLen;
areaCA1or = areaCA1or*GLO_VARS.pixLen*GLO_VARS.pixLen;




function [lenHil,lenCA3,lenCA1] = getRegionLengths(centerLine,polygonVertList,hashPyrStart,hashCA2)
% measure length of centerline, using the intersections of the centerline
% with the polygon as endpoints.

% discard the parts of the centerline that fall outside of the hippocampus proper
[ci,ri] = polyIntPoly(centerLine(:,2),centerLine(:,1),[polygonVertList(:,2); polygonVertList(1,2)],[polygonVertList(:,1); polygonVertList(1,1)]); % find where the line intersects the polygon.  coordinates are listed in the direction of the end of the line.
pt1rc = [ri(1) ci(1)]; % intersection points between CENTERLINE and VERTLIST polygon
pt2rc = [ri(2) ci(2)];

keepLinePts = inpolygon(centerLine(:,2),centerLine(:,1),polygonVertList(:,2),polygonVertList(:,1)); % identify points on CENTERLINE that fall outside of the polygon VERTLIST
centerLine(~keepLinePts,:)=[]; % discard line points outside of the polygon

if pdist2(pt1rc,centerLine(1,:)) < pdist2(pt1rc,centerLine(end,:)) % if the first intersection point, PT1RC, is closer to the first end of centerLine
    centerLine = [pt1rc; centerLine; pt2rc]; % add the endpoints to the appropriate ends of the line
else
    centerLine = [pt2rc; centerLine; pt1rc]; % add the endpoints to the appropriate ends of the line
end

% find the position where hashPyrStart intersects the centerLine
[~,~,iiPyrStart] = polyIntPoly(centerLine(:,2),centerLine(:,1),hashPyrStart(:,2),hashPyrStart(:,1)); % find where the line intersects the polygon.  iiPyrStart has 2 values, one for CENTERLINE and one for HASHPYRSTART, that give the index of the polyline segment that gives rise to the intersection in each respective line
[~,~,iiCA2] = polyIntPoly(centerLine(:,2),centerLine(:,1),hashCA2(:,2),hashCA2(:,1));

% break centerLine into segments that correspond to CA1, CA3, and hilus
lineCA1 = centerLine(1:iiCA2(1),:);
lineCA3 = centerLine(iiCA2(1)+1:iiPyrStart(1),:);
lineHilus = centerLine(iiPyrStart(1)+1:end,:);

lenHil=arcLength(lineHilus);
lenCA3=arcLength(lineCA3);
lenCA1=arcLength(lineCA1);





function lenLine = arcLength(lineIn)
% given a polyline in 2D space, return the total length of that line

% the length of the line is equal to the sum of the length of all of its
% segments.  find the length of the first segment, then call this function
% recursively to get the rest of the length.

if size(lineIn,1)==2, % if there are only 2 points in the line, measure the distance
    lenLine = sqrt( (lineIn(2,1)-lineIn(1,1))^2 + (lineIn(2,2)-lineIn(1,2))^2 );
else
    lenLine = sqrt( (lineIn(2,1)-lineIn(1,1))^2 + (lineIn(2,2)-lineIn(1,2))^2 ) + arcLength(lineIn(2:end,:)); % the length of the line is the length of the first segment plus the length of the rest of the line (recursive)
end





function [areaHil,areaCA3,areaCA1] = getRegionArea(poly,intLinePoly)
% get the area, in square pixels, of the polygons that enclose the hilus,
% CA3, and CA1.  segments aren't broken up to any greater precision than
% those provided in POLY, so there is some imprecision in these areas.

areaHil=0;
areaCA3=0;
areaCA1=0;

for i=1:intLinePoly(1),
    areaHil = areaHil + polyarea(poly{i}(:,1),poly{i}(:,2)); % add the area of each segment
    % figure(65),plot([poly{i}(:,1); poly{i}(1,1)],[poly{i}(:,2); poly{i}(1,2)],'k'),axis ij,axis equal,pause
end

for i=intLinePoly(1)+1:intLinePoly(2),
    areaCA3 = areaCA3 + polyarea(poly{i}(:,1),poly{i}(:,2)); % add the area of each segment
    % figure(65),plot([poly{i}(:,1); poly{i}(1,1)],[poly{i}(:,2); poly{i}(1,2)],'k'),axis ij,axis equal,pause
end

for i=intLinePoly(2)+1:length(poly),
    areaCA1 = areaCA1 + polyarea(poly{i}(:,1),poly{i}(:,2)); % add the area of each segment
    % figure(65),plot([poly{i}(:,1); poly{i}(1,1)],[poly{i}(:,2); poly{i}(1,2)],'k'),axis ij,axis equal,pause
end








