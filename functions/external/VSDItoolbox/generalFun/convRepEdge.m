function Dout = convRepEdge(D,kernel)
% CONVREPEDGE convolves the n-dimensional array D with KERNEL.  
% Before convolution, the array is padded with edge values to prevent
% wonky edge effects in the resulting matrix.
% KERNEL should have odd-numbered lengths in all dimensions,
% with the same number of dimensions as D.
% 
% Example: for smoothing a 3D movie 3 pixels in the rows direction,
% 3 pixels in the columns direction, and 5 samples in the time direction,
% use the kernel "ones(3,3,5)/(3*3*5)".
%


Dpad = padarray(D,round(size(kernel)/2)-1,'replicate','both'); % length of convolution is MAX([LENGTH(A)+LENGTH(B)-1,LENGTH(A),LENGTH(B)].  in our case this will almost certainly be length(a)+length(b)-1

Dout = convn(Dpad,kernel,'valid');
