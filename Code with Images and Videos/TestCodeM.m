%% Final Year Project test code
% Written and owned by Luca Ricagni

%% Read image in

I = imread('SimpleBlackCircle1.png');  % reads image file

%% Display image

imshow(I) % displays image

% whos I  % shows size of image file


%% Display histogram of image intensities distribution
% figure
% imhist(I)


%% Histogram equalisation
I2 = histeq(I);
% figure
% imhist(I2)


%% Write new image to disk file
imwrite(I2, 'pout.png');

%% Check contents of new file
imfinfo('pout.png')






