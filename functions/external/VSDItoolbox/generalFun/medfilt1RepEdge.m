function out = medfilt1RepEdge(D,filtLen,blkSz,dim)
% MEDFILT1REPEDGE first pads the signals along dimension DIM with 
% (FILTLEN/2) zeros at both the beginning and end of signals.
% Signals are then median filtered (MEDFILT1) along dimension DIM,
% and the padding is stripped to return OUT of the same size as input D.

padSize=zeros(ndims(D),1);
padSize(dim)=(filtLen-1)/2;

if rem(filtLen-1,2),
    error('FILTLEN must be odd for median filtering')
end

out=padarray(D,padSize,'replicate','both');

out = medfilt1(out,filtLen,blkSz,dim); % median filter temporal traces.  DAVG traces are first padded with repeated edge values to avoid erroneous edge effects.

% find which dimension is shifted
szDiff = size(out)-size(D);

indStr=[];
for i=1:length(szDiff),
    indStr = [indStr '1+szDiff(' num2str(i) ')/2:end-szDiff(' num2str(i) ')/2,']; % assemble a string to index the portion of the padded medfilt1 output that is the same size as the input D
end
indStr(end)=[]; % remove extra comma at end of string

% % debugging
% eval(['size(out(' indStr '));'] )
% szDiff

out = eval(['out(' indStr ');'] ); % crop OUT so it is the same size as the input D