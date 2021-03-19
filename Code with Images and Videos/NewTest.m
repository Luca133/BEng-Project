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
V = VideoReader('StageThreeRed.mp4');
% V = VideoReader('StageThreeRed2.mp4');
% V = VideoReader('StageThreeWhite.mp4');
% V = VideoReader('StageThreeWhite2.mp4');
% V = VideoReader('StageThreeWhite3.mp4');

%% Declare variables

counter = 1; % Used in for loop

timeInterval = 0.5; % Interval for frames

frameIncrementSize = round((V.NumberOfFrames/V.Duration)*timeInterval); % Calculate frames per 0.5seconds

a = round(V.NumberOfFrames/frameIncrementSize); % Calculates how many values to store

centreCoordinates = zeros(a,2); % Initialise matrix to store centre coordinates

frameNumbers = zeros(a,1); % Initialise matrix to store the frame numbers

% Variables for thresholding

mean = 0;
threshold = 0;
middleVal = 0;
lowerTotal = 0;
upperTotal = 0;
lowercount = 0;
uppercount = 0;
pixelnumbers = zeros(1,255);

%% Loop to go through video in specified increments
for i=1:frameIncrementSize:V.NumberOfFrames
    
    frame = read(V,i);
    
    %% Thresholding code
    frame = rgb2gray(frame);
    %     frame = rgb2hsv(frame);
    %     frame = frame(:,:,2);
    framedimensions = size(frame);
    
    sumOfPixelsInFrame = sum(sum(frame));
    mean = round(sumOfPixelsInFrame/(prod(framedimensions)));
    
    for j=1:255
        pixelnumbers(j) = sum(frame(:)== j);
    end
    
    middleVal = median(frame,'all');
    
    threshold = mean;
    
    while(1)
        for k=1:framedimensions(1)
            for l=1:framedimensions(2)
                if frame(k,l) < threshold
                    %add to lower mean
                    lowerTotal = lowerTotal + double(frame(k,l));
                    lowercount = lowercount + 1;
                else
                    %add to upper mean
                    upperTotal = upperTotal + double(frame(k,l));
                    uppercount = uppercount + 1;
                end
            end
        end
        
        %mean = mean of upper and lower
        mean = round(((lowerTotal/lowercount) + (upperTotal/uppercount))/2);
        
        if mean == threshold
            break;
        else
            %reset counts
            lowerTotal = 0;
            upperTotal = 0;
            lowercount = 0;
            uppercount = 0;
            
            threshold = mean;
        end
    end
    
    for o=1:framedimensions(1)
        for p=1:framedimensions(2)
            if frame(o,p) < threshold
                frame(o,p) = 0;
            else
                frame(o,p) = 255;
            end
        end
    end
    
    minSize = 1000;
    
    t = bwlabel(frame);
    
    % subplot(121);
    % imshow(t,[])
    
    for k = 1:max(t(:))
        a = t == k;
        if sum(a(:)) < minSize
            t(t==k) = 0;
        end
    end
    
    imshow(frame);
    
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

%% Manipulate Data for better graph
% Find all the zeros in the matrix
matrixDimensions = size(centreCoordinates);

zeroCount = 0;

for c=1:matrixDimensions(1)
    if centreCoordinates(c,1) == 0
        zeroCount = zeroCount + 1;
    end
end

temp = centreCoordinates;
centreCoordinates = zeros(matrixDimensions(1)-zeroCount,2);
index = 1;

% Cut 0s out of matrix and find the new dimensions
for d=1:matrixDimensions(1)
    if temp(d,2) ~= 0
        centreCoordinates(index,:) = temp(d,:);
        index = index + 1;
    end
end

% Find where the "jump" happens
linecut = 0;
for e=1:(matrixDimensions(1)-1)
    if centreCoordinates(e,2)*percentageDiff < centreCoordinates(e+1,2)
        linecut = e;
        break;
    end
end

centresForLine = centreCoordinates(1:e,:);
matrixDimensions = size(centreCoordinates);

%% 2d graph plot

scatter(centreCoordinates(:,1), centreCoordinates(:,2), 'x')

xlabel('X-Coordinate (Pixels)');
ylabel('Y-Coordinate (Pixels)');

hold on

% Plot line of best fit
fit = polyfit(centresForLine(:,1), centresForLine(:,2), 1);
%plot(polyval(fit, centreCoordinates(:,1)), centreCoordinates(:,2))
fitx = linspace(0,max(centresForLine(:,1)),5);
fity = fit(1)*fitx + fit(2);
plot(fitx,fity,'g-')

% Put y-axis along top and put (0,0) in top left corner
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');


%% Find distances from points to line of best fit (unnecessary)

yCoordOfLine = zeros(matrixDimensions(1),1);
distanceToLine = zeros(matrixDimensions(1),1);
for f=1:matrixDimensions(1)
    yCoordOfLine(f,1) = fit(1)*centreCoordinates(f,1) + fit(2); % Y Coord of line at given x values
    distanceToLine(f,1) = centreCoordinates(f,2) - yCoordOfLine(f,1); % Calculate distance to line
end


%% Plot lines between points and line of best fit
for g=1:matrixDimensions(1)
    plot([centreCoordinates(g,1) centreCoordinates(g,1)], [centreCoordinates(g,2) yCoordOfLine(g,1)], '--r')
end
