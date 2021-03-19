%% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code finds the cargo at regular points in a video
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
% V = VideoReader('StageThreeRed.mp4');
% V = VideoReader('StageThreeRed2.mp4');
V = VideoReader('StageThreeWhite.mp4');
% V = VideoReader('StageThreeWhite2.mp4');
% V = VideoReader('StageThreeWhite3.mp4');

%% Declare variables

counter = 1; % Used in for loop

timeInterval = 0.5; % Interval for frames

frameIncrementSize = round((V.NumberOfFrames/V.Duration)*timeInterval); % Calculate frames per 0.5seconds

a = round(V.NumberOfFrames/frameIncrementSize); % Calculates how many values to store

centreCoordinates = zeros(a,2); % Initialise matrix to store centre coordinates

frameNumbers = zeros(a,1); % Initialise matrix to store the frame numbers


%% Loop to go through image in specified increments
for i=1:frameIncrementSize:V.NumberOfFrames
    
    frame = read(V,i);
    frame = rgb2gray(frame);
    
    u=fspecial('unsharp',0.5);
    pu=filter2(u,frame);
    
    imshow(pu/255);
    
    %% Find the cargo (if it is there) using Hough Circle Transform
    
    [centers, radii, metric] = imfindcircles(frame, [36 60], 'ObjectPolarity', 'bright');
    
    %% Draw blue outlines on the circles
    
    % Find number of circle centers
    b = numel(centers);
    numOfCircles = b / 2;
    
    viscircles(centers, radii,'EdgeColor','b');
    
    frameNumbers(counter,:) = i;
    
    if(numOfCircles > 0)
        centreCoordinates(counter,:) = centers;
    end
    counter = counter + 1;
    
end

%% Plot the graph

% plot(frameNumbers,centreCoordinates(:,1), centreCoordinates(:,2), 'x')


%% Plot in 3d
% scatter3(frameNumbers,centreCoordinates(:,1), centreCoordinates(:,2), 'x')

% ylabel('X-Coordinate (Pixels)');
% zlabel('Y-Coordinate (Pixels)');
% xlabel('Frame Number');
% hold on


%% 2d test (.' is used to transpose matrices)

xcoords = centreCoordinates(:,1);
ycoords = centreCoordinates(:,2);

scatter(xcoords, ycoords, 'x')

xlabel('X-Coordinate (Pixels)');
ylabel('Y-Coordinate (Pixels)');

hold on

% Code to plot line of best fit (doesn't work)
% fit = polyfit(centreCoordinates(:,1), centreCoordinates(:,2), 1);
% plot(polyval(fit, centreCoordinates(:,1)), centreCoordinates(:,2))

% Put y-axis along top and put (0,0) in top left corner
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

