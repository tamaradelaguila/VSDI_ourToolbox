function h = roiDrawLines(lineIn)
% given the coordinates of vertices of a region-of-interest lineIn,
% ROIDRAWPOLY calls IMPOLY to draw the lineIn.  
% ROIDRAWPOLY returns a handle to the resulting IMPOLY object.
% The main operation performed by ROIDRAWPOLY is reformatting 
% the coordinate list in a form that is acceptable to 
% IMPOLY's (silly) coordinate list format.

% lineIn is a 2D array that is [ri, ci]
ri=lineIn(:,1);
ci=lineIn(:,2);

coordlist='['; % start text string (for formatting coordinates in IMPOLY's silly format)
for i=1:length(ri),
    coordlist = [coordlist num2str(ri(i)) ',' num2str(ci(i)) '; '];
end
coordlist=coordlist(1:end-1); % remove last space from the list
coordlist(end)=']'; % replace last char in coordlist (which was a semicolon) with a closing bracket

h = impoly(gca,eval(coordlist),'Closed',0);
setColor(h,[0 0 0]); % draw lines in black
setVerticesDraggable(h,0)