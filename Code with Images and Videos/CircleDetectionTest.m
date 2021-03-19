% Circle detection test


%% Clear

close all
clear
clc

%% Import image

Ic = imread('CoinsImage.png');  % reads image file
imshow(Ic)
% d = imdistline % Creates moveable line to measure distances

%% Find all the circles with radius r pixels in the range [15, 30]

[centers, radii, metric] = imfindcircles(Ic,[15 30]);

%% Retain the five strongest circles according to the metric values

centersStrong5 = centers(1:5,:); 
radiiStrong5 = radii(1:5);
metricStrong5 = metric(1:5);

%% Draw the five strongest circle perimeters over the original image
 
viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');