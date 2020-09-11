function [detrended_movie] = filter_bleachlike(movie,window)
%BLEACH_FILTER detrends each pixel of the data and set the origin to the
%origin of the data

% INPUT:
% movie: 3D movie data
% detrend mode : 'linear', 'cuadratic'
% window of frames to center the
% TO-DO : 2Ddetrended_pulled
%   OUTPUT
% 'detrended_movie'

%reshape 
x = size(movie,1);
y =size(movie,2);
t=size(movie,3);
pixels = x*y;

movie2D= reshape(movie,pixels,t);

% detrend and pull to origin
for px = 1: pixels
detrended(px,:) = detrend(movie2D(px,:),1);

%SET the origin of the detrended to fit the origin of the real data,
%pulling from the wave to make the origins of the timeseries to meet
origin_data = 0 + mean(movie2D(px, 1:window)); %calculate the start point
origin_detrend =  mean(detrended(px, 1:window)); %calculate how much differs from start point
detrended_pulled(px,:) = detrended(px,:) - origin_detrend + origin_data;
end

%shape back
detrended_movie = reshape(detrended_pulled,x,y,t);
end

