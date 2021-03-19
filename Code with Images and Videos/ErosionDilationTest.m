% %% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code is a test for erosion and dilation
% By Luca Ricagni

%% Clear

close all
clear
clc
%% Import video
% Stage one videos
% V = VideoReader('StageOneWhite.mp4');

% Stage two videos
% V = VideoReader('StageTwoRed.mp4');
% V = VideoReader('StageTwoWhite.mp4');
% V = VideoReader('StageTwoWhite2.mp4');

% Stage three videos
% V = VideoReader('StageThreeBlue.mp4');
V = VideoReader('StageThreeRed.mp4');
% V = VideoReader('StageThreeRed2.mp4');
% V = VideoReader('StageThreeWhite.mp4');
% V = VideoReader('StageThreeWhite2.mp4');
% V = VideoReader('StageThreeWhite3.mp4');

%% Extract first frame for use as a control

controlFrame = read(V,1);
controlFrame = rgb2gray(controlFrame);
controlFrame = double(controlFrame);
% imshow(controlFrame)

%% Declare variables (these can potentially be edited)

timesToErode = 1;

timesToDilate = 10;


frame = read(V,200);
frame = rgb2gray(frame);
frame = double(frame);

frameDiff = frame-controlFrame; % Find differences in values
frameDiff = abs(frameDiff);
%     frameDiff = double(frameDiff);


% Thresholding
frameSize = size(frameDiff);
for j=1:frameSize(1)
    for k=1:frameSize(2)
        % Noise filter with flat value
        if frameDiff(j,k) > 130
            % set value to 255
            frame(j,k) = 255;
        else
            % set value to 0
            frame(j,k) = 0;
        end
    end
end

% Dilation
frameTemp = frame;
for b=1:timesToDilate
    for j=2:frameSize(1)-1
        for k=2:frameSize(2)-1
            % if certain numOfGoodNeighbours are white
            numOfGoodNeighbours = 0;
            if frame(j,k-1) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j-1,k) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j+1,k) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j,k+1) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            
            if numOfGoodNeighbours >= 1
                frameTemp(j,k) = 255;
            end
            
        end
    end
%     frame = frameTemp;
end

frame = frameTemp;
imshow(frame)

% Erosion
frameTemp = frame;
for a=1:timesToErode
    for j=2:frameSize(1)-1
        for k=2:frameSize(2)-1
            if frame(j,k-1) == 0 || frame(j-1,k) == 0 || frame(j+1,k) == 0 || frame(j,k+1) == 0
                frameTemp(j,k) = 0;
            end
        end
    end
    frame = frameTemp;
end
frame = frameTemp;
    imshow(frame)

% Dilation
for b=1:timesToDilate
    for j=2:frameSize(1)-1
        for k=2:frameSize(2)-1
            % if certain numOfGoodNeighbours are white
            numOfGoodNeighbours = 0;
            if frame(j,k-1) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j-1,k) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j+1,k) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            if frame(j,k+1) == 255
                numOfGoodNeighbours = numOfGoodNeighbours + 1;
            end
            
            if numOfGoodNeighbours >= 2
                frameTemp(j,k) = 255;
            end
            
        end
    end
    frame = frameTemp;
end

frame = frameTemp;
imshow(frame)

%% Blur and rethreshold
windowSize = 51;
kernel = ones(windowSize) / windowSize ^ 2;
blurryImage = conv2(single(frame), kernel, 'same');
binaryImage = blurryImage > 0.5; % Rethreshold


frame = binaryImage;

imshow(frame)

[centers, radii, metric] = imfindcircles(frame,[25 70],'ObjectPolarity','bright');
% d = imdistline % Creates moveable line to measure distances



%% %%%%%%%%% TESTING %%%%%%%%%%%%%%%%%%

% Thresholding
frameSizeh = size(frameh);
framehNew=frameh;
for j=1:frameSizeh(1)
    for k=1:frameSizeh(2)
        % Noise filter with flat value
        if frameh(j,k) > 0.55
            % set value to 255
            framehNew(j,k) = 255;
        else
            % set value to 0
            framehNew(j,k) = 0;
        end
    end
end

imshow(framehNew)

[centers, radii, metric] = imfindcircles(framehNew, [30 60], 'ObjectPolarity', 'bright');


[centers, radii, metric] = imfindcircles(t(:,:,3).*t(:,:,1).*t(:,:,2), [30 60], 'ObjectPolarity', 'bright');
    








