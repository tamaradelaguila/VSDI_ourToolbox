function Dout = insertConstantRows(Din,rowIndZeros,value)
% insert rows of VALUE into the matrix at indices specified in ROWINDZEROS

if nargin==2,
    value=0; % set rows to 0 by default 
end

szIn = size(Din);

if ~isempty(rowIndZeros), % if the input isn't empty, add rows
    
    Dout = zeros(szIn(1)+length(rowIndZeros),szIn(2)); % preallocate
    Dout(:) = value; % assigns the input VALUE to all sites.  this value will be replaced everywhere except for the rows specified by the input ROWINDZEROS
    
    Dout(1:rowIndZeros(1)-1,:) = Din(1:rowIndZeros(1)-1,:);
    
    if length(rowIndZeros)>1, % process all the "middle" entries in the rowIndZeros list
        for i=2:length(rowIndZeros),
            % debug
            % outInd1 = rowIndZeros(i-1)+1
            % outInd2 = rowIndZeros(i)-1
            % inInd1  = rowIndZeros(i-1)-i+2
            % inInd2  = rowIndZeros(i)-i
            Dout(rowIndZeros(i-1)+1:rowIndZeros(i)-1,:) = Din(rowIndZeros(i-1)-i+2:rowIndZeros(i)-i,:);
        end
    end
    
    % debug
    % inInd1 = rowIndZeros(end)-length(rowIndZeros)+1
    
    Dout(rowIndZeros(end)+1:end,:) = Din(rowIndZeros(end)-length(rowIndZeros)+1:end,:);
    
else % if the input ROWINDZEROS was empty, just return the input DIN
    Dout = Din;
end