function writeTiffMovie(img,filename,imResizeFactor)
% writeTiffMovie(img, filename): write a 3D (black and white) or 4D (color) image file in uncompressed tif format

if nargin == 2,
    imResizeFactor=1;
end

wr_mode = 'overwrite';

if ndims(img)==4,
    
    for i=1:size(img,4),
        imwrite(imresize(double(img(:,:,:,i)),imResizeFactor,'nearest'),filename, 'tif', 'Compression','lzw','WriteMode',wr_mode);
        wr_mode = 'append';
    end
    
elseif ndims(img)==3,
    
    for i=1:size(img,3),
        imwrite(imresize(double(img(:,:,i)),imResizeFactor,'nearest'),filename, 'tif', 'Compression','lzw','WriteMode',wr_mode);
        wr_mode = 'append';
    end
    
else
    error('Requires image stack in in 3D [x,y,t] or 4D [x,y,color,t]')
end


