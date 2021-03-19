%% Clear

close all
clear
clc

%% Read in image and convert to grayscale

I_c = imread('ColourTestImg.jpg');
% imshow(I_c)

I_g = rgb2gray(I_c);
% imshow(I_g)

%% Salt and pepper noise

I_sp = imnoise(I_g, 'salt & pepper');
imshow(I_sp)

%% Gaussian noise

I_ga = imnoise(I_g, 'gaussian');

imshow(I_ga)

%% Speckle noise

I_spk = imnoise(I_g, 'speckle');

imshow(I_spk)