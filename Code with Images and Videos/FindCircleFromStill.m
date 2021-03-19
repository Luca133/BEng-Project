%% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code finds the cargo in a still close up image
% NOTE - Due to the number of test images used some are differnt sizes and
% thus may need to be shrunk
% By Luca Ricagni

%% Clear

close all
clear
clc
%% Declare variables

imageScaleFactor = 0.1;

%% Import image

% Ic = imread('FactorySmall.png'); % Working one because it is shrunk

% Ic = imread('3CircleTest.png');
% Ic = imread('5CargoTestW.png'); Doesn't work becuase the backgroung is white
% Ic = imread('5CargoTest.png');
% Ic = imread('6CargoFactoryTest.png');
% Ic = imread('WhiteCargoTest.png');
% Ic = imread('BlueCargoTest.png');

Ic = imread('BlueBayTest.jpg');

% Ic = imread('FactoryCirclePic.jpg'); % One that should work

% Ic = imread('CoinsImageTest.png');  % reads image file
% Ic = imread('CoinsImageTest2.png'); 
% Ic = imread('SimpleBlackCircle1.png');
% Ic = imread('CountersG.png');
% Ic = imread('SmallCircle.png'); 
% Ic = imread('Single2.png'); 
% Ic = imread('FactoryCirclePic.jpg');
% Ic = imread('FactorySmall.png');
% Ic = imread('SingleCoin.png');
% Ic = imread('CoinsImage.png');
% Ic = imread('copytest.png');
% Ic = imread('PlainWhiteCircle2.png');

% imshow(Ic)

%% Resize the image to be smaller

% Ic = rgb2hsv(Ic);

Ic = imresize(Ic,imageScaleFactor); % Resizes based off scale factor

% Ic = imresize(Ic,[500 400]); % Resizes to specified num of rows/columns

% imshow(Ic)

%% Change from rgb to greyscale/HSV

% Using Greyscale
% Ig = rgb2gray(Ic);
% imshow(Ig)

% Ic = rgb2hsv(Ic);
imshow(Ic)

% Using Hue
% I1 = Ic(:,:,1);
% imshow(I1)

% Using Saturation
% I2 = Ic(:,:,2);
% imshow(I2)

% Using Value
% I3 = Ic(:,:,3);
% imshow(I3)

%% Find the cargo (if it is there) using Hough Circle Transform

% d = imdistline % Creates moveable line to measure distances

% [centers, radii, metric] = imfindcircles(Ic,[401 500], 'ObjectPolarity','bright')
% [centers, radii, metric] = imfindcircles(Ic,[300 400], 'ObjectPolarity','bright')

% Working ones
[centers, radii, metric] = imfindcircles(Ic,[10 30],'ObjectPolarity','bright')

% [centers, radii, metric] = imfindcircles(Ic,[30 70],'ObjectPolarity','bright');

% [centers, radii, metric] = imfindcircles(Ic,[50 80],'ObjectPolarity','bright');


%% Retain the five strongest circles according to the metric values

% x = numel(centers);
% x = x / 2;
% centersStrong5 = centers(1:x,:); 
% radiiStrong5 = radii(1:x);
% metricStrong5 = metric(1:x);

% Draw the five strongest circle perimeters over the original image
 
% viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');

%% Draw blue outlines on the circles

% Find number of circle centers 
x = numel(centers);
numOfCircles = x / 2;

viscircles(centers, radii,'EdgeColor','b');


