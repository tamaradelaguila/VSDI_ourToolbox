function [output] = filter_spatial(input, windowSize)
% SPATIAL AVERAGE FILTER OF THE IMAGE (2D input) OR OF THE FRAMES OF A
% MOVIE (3Dinput)

% performs "P x P" pixels average filter of 2D filter processing. We normally set the parameter "P" to 9.

% If The value defined as D(t, x, y) on the coordinates of (x, y) at the frame number "t" will be replaced with the averaged value - in the area "P x P".
% If input is an image (dim=2), returns an image filtered.
% If the input is a movie (3D), ut returns a movie in which each frame has
% been filtered independently

kernel = ones(windowSize);
data_dim = length(size(squeeze(input)));

if data_dim ==2 
kernel = kernel / sum(kernel(:));
output = conv2(double(input), kernel, 'same');
end

if data_dim ==3
data3D = input; 
n_frame = size(input,3); 

for fr = 1:n_frame
frame = squeeze(data3D(:,:,fr));
kernel = kernel / sum(kernel(:));
localAverageImage = conv2(double(frame), kernel, 'same');
    
output(:,:,fr) = localAverageImage; 
end

end

end
