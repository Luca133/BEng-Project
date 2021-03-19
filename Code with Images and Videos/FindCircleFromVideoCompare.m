%% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code finds the cargo at regular points in a video using comparison
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
V = VideoReader('StageThreeBlue.mp4');
% V = VideoReader('StageThreeRed.mp4');
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

timesToErode = 3;

timesToDilate = 10;

percentageDiff = 1.1; % Difference you look for to decide what data to use for line of best fit

timeInterval = 0.5; % Interval for frames in seconds

%% Declare other variables

frameIncrementSize = round((V.NumberOfFrames/V.Duration)*timeInterval); % Calculate frames per 0.5seconds

a = round(V.NumberOfFrames/frameIncrementSize); % Calculates how many values to store

centreCoordinates = zeros(a,2); % Initialise matrix to store centre coordinates

frameNumbers = zeros(a,1); % Initialise matrix to store the frame numbers

counter = 1; % Used in for loop


%% Loop to go through image in specified increments
for i=1:frameIncrementSize:V.NumberOfFrames
    
    frame = read(V,i);
    frame = rgb2gray(frame);
    frame = double(frame);
    
    frameDiff = frame-controlFrame; % Find differences in values
    frameDiff = abs(frameDiff);
%     frameDiff = double(frameDiff);
    
    frameSize = size(frameDiff);
%     frameTemp = zeros(frameSize(1), frameSize(2));
    for j=1:frameSize(1)
        for k=1:frameSize(2)
            % Noise filter comparing percentage diff of values (not good)
%             pixelDiff = double((frame(j,k)/controlFrame(j,k)));
%             if pixelDiff > 1.1
%                 % set value to 255
%                 frame(j,k) = 255;
%             else
%                 % set value to 0
%                 frame(j,k) = 0;
%             end
            
            % Noise filter with flat value
            if frameDiff(j,k) > 150
                % set value to 255
                frame(j,k) = 255;
            else
                % set value to 0
                frame(j,k) = 0;
            end
        end
    end
    
%     imshow(frame)
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
    end
    frame = frameTemp;
%     imshow(frame)
    
    % Dilation
    for b=1:timesToDilate
        for j=2:frameSize(1)-1
            for k=2:frameSize(2)-1
                % if 3/4 neighboors are white
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
    end
    
    frame = frameTemp;
    imshow(frame)
end



