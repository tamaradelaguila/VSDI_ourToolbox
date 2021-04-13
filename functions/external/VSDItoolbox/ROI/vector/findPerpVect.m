function [normVrc originPt] = findPerpVect(pt1,pt2,length)

normVrc = null(pt2-pt1)'; % find the normal vector
normVrc = normVrc*length; % make the vector long
normVrc = [-normVrc; normVrc]; % make the vector point in both directions

originPt=[(pt1(1)+pt2(1))/2 (pt1(2)+pt2(2))/2];
normVrc(:,1)=normVrc(:,1)+(pt1(1)+pt2(1))/2; % move the vector so that the origin of the vector is lined up with the midpoint of the input line segment
normVrc(:,2)=normVrc(:,2)+(pt1(2)+pt2(2))/2;