%% Import picture of disk from factory

clear
close all
clc

%% Read image in

I = imread('FactoryCirclePic.jpg');  % reads image file

%% Display image

imshow(I) % displays image

%% Display histogram of image intensities distribution
figure
imhist(I)

%% Histogram equalisation
I2 = histeq(I);
figure
imhist(I2)

%% Thresholding

I3 = imbinarize(I);
figure
imhist(I3)




