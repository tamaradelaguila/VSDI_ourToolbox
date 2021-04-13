function [lineOut, indNew] = insertPointIntoVector(lineRC,r1,c1,debug)
% given a discretely sampled line LINERC and a point [R1 C1] that falls
% somewhere on that line, INSERTPOINTINTOVECTOR first determines if the 
% input point is already on the line.  If the point is already included in 
% LINERC, the index of the point is returned.  If the point is not
% already included in LINERC, INSERTPOINTINTOVECTOR inserts the point 
% into the vector at the appropriate location, and returns the new vector
% and the index of the inserted point.
%
% LINERC is [sampleNums 2], where the 2nd dimension numbers the axes
% (1=row,2=col).

if nargin==3,
    debug=0;
end

distR=lineRC(:,1)-r1;
distC=lineRC(:,2)-c1;

isOnLine = zeros(size(lineRC,1),1); % preallocate
for i=1:size(lineRC,1), % determine if the point (r1,c1) is already on the line
    if distR(i)==0,
        if distC(i)==0,
            isOnLine(i)=1;
        end
    end
end

if sum(isOnLine), % if anything is >0 in isOnLine
    lineOut=lineRC;
    indNew=find(isOnLine,1);
else
    % If the point isn't already on the line, march through the line,
    % point by point, and find the appropriate position to insert the
    % point (r1,c1).
    
    segLen =1; % hard coded width of diamond-shaped region between points that defines "on the line"
    for i=2:size(lineRC,1),
        %segLen = pdist2(lineRC(i-1,:),lineRC(i,:));
        [normVrc originPt] = findPerpVect(lineRC(i-1,:),lineRC(i,:),segLen);
        boxVerts = [lineRC(i-1,:); normVrc(1,:); lineRC(i,:); normVrc(2,:)];
        isOnLine(i)=inpolygon(r1,c1,boxVerts(:,1),boxVerts(:,2)); % if the point is in the box we drew over the current line segment, the point is on the line at this coordinate
        
        if debug,
            figure(222)
            hold off
            plot(lineRC(:,2),lineRC(:,1))
            hold on
            plot(boxVerts(:,2),boxVerts(:,1),'r.')
        end
    end
end

switch sum(isOnLine)
    
    case 0
        indNew = [];
        lineOut = lineRC;
        disp(['Error: point ' num2str(r1) ', ' num2str(c1)  ' not found on line'])
        
    case 1
        indNew = find(isOnLine,1);
        lineOut = [lineRC(1:indNew-1,:); r1 c1; lineRC(indNew:end,:)]; % insert the point into the line
        
    otherwise
        if debug,
            disp(['Warning: point ' num2str(r1) ', ' num2str(c1)])
            disp([' could be assigned to ' num2str(sum(isOnLine)) ' segments!  Using first.'])
        end
        indNew = find(isOnLine,1);
        lineOut = [lineRC(1:indNew-1,:); r1 c1; lineRC(indNew:end,:)]; % insert the point into the line
end

if debug,
    figure(222)
    hold off
    plot(lineOut(:,2),lineOut(:,1))
    hold on
    plot(lineOut(indNew,2),lineOut(indNew,1),'r.')
end


