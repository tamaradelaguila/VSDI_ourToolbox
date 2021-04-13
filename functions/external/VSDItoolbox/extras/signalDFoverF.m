function DFoverF = signalDFoverF(D,BG_FRAMES)
% divide D (either a 4D stack of movies or a single movie) by the 
% baseline image.  The baseline image is the average image of the 
% movie frames numbered in BG_FRAMES.
%
% D is expected to be int16
% DFOVERF is returned as int32 with values equal to 10e7*(fractional fluorescence)

szD=size(D);

DFoverF=zeros(szD,'int32'); % preallocate

if ndims(D)==4,
    for i=1:szD(4),
        baselineIm = squeeze(mean(D(:,:,BG_FRAMES,i),3)); % take the average value for all pixels during the times defined in BG_FRAMES (this is a "background image")
        baselineArray = repmat(baselineIm,[1 1 szD(3)]);
        
        oneMov=double(D(:,:,:,i)); % put the current movie in a double type array
        DFoverF(:,:,:,i)=int32(  ( oneMov./baselineArray-1 )*10e7  ); % this is the same as "(D-baseline)/baseline" as described in Carlson Coulter 2008, but computationally faster.
    end
    
elseif ndims(D)==3,
    baselineIm = squeeze(mean(D(:,:,BG_FRAMES),3)); % take the average value for all pixels during the times defined in BG_FRAMES (this is a "background image")
    baselineArray = repmat(baselineIm,[1 1 szD(3)]);
    
    oneMov=double(D); % put the current movie in a double type array
    DFoverF=int32(  ( oneMov./baselineArray-1 )*10e7  ); % this is the same as "(D-baseline)/baseline" as described in Carlson Coulter 2008, but computationally faster. 
    
elseif ndims(D)==2 && min(size(D))>1, % if the array is multi-channel [channels time]
    baselineVal=squeeze(mean(D(:,BG_FRAMES),2)); % take the average value for all pixels during the times defined in BG_FRAMES (this is a "background value" for all channels)
    baselineArray = repmat(baselineVal,[1 szD(2)]);
    
    sigs=double(D); % put the signals in a double type array (same scheme as with ONEMOV, in higher dimension cases above)
    DFoverF=int32(  ( sigs./baselineArray-1 )*10e7  );
    
elseif ndims(D)==2 && min(size(D))==1, % if the input is a vector
    flip=0; % for transposing the array back at the end of processing, in case of a 1D row vector
    if size(D,1)==1,
        D=D';
        flip=1;
    end
    
    baselineVal=mean(D(BG_FRAMES));
    sigs=double(D); % just one signal
    DFoverF=int32( ( sigs/baselineVal-1)*10e7  );
    
    if flip,
        DFoverF=DFoverF';
    end
end