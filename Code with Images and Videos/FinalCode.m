%% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code finds the cargo from a video using the Hue frame
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

%% Declare variables (these can potentially be edited)

percentageDiff = 1.1; % Difference you look for to decide what data to use for line of best fit

timeInterval = 0.5; % Interval for frames in seconds

%% Declare other variables

frameIncrementSize = round((V.NumberOfFrames/V.Duration)*timeInterval); % Calculate frames per 0.5seconds

a = round(V.NumberOfFrames/frameIncrementSize); % Calculates how many values to store

centreCoordinates = zeros(a,2); % Initialise matrix to store centre coordinates

frameNumbers = zeros(a,1); % Initialise matrix to store the frame numbers

counter = 1; % Used in for loop

%% Extract first frame for use as a control

controlFrame = read(V,1);
controlFrame = imcrop(controlFrame, [0 0 1000 500]);
controlFrame = rgb2hsv(controlFrame);
controlFrame = controlFrame(:,:,1);
controlFrame = double(controlFrame);

%% Loop to go through image in specified increments
for i=1:frameIncrementSize:V.NumberOfFrames
    
%     i=200; %Used for testing frame which definitely has cargo in it
    frame = read(V,i);
    frame = imcrop(frame, [0 0 1000 500]);
    %frame = rgb2gray(frame);
    frame = rgb2hsv(frame);
    
    % Select hue, saturation or value
    frameh = frame(:,:,1); 
    frames = frame(:,:,2);
    framev = frame(:,:,3);
    
    frameInUse = frameh;
    
%         imshow(frame);
    
    centers = zeros(1,2);
    
    
    
    frameDiff = frameInUse-controlFrame; % Find differences in values
    frameDiff = abs(frameDiff);
    %     frameDiff = double(frameDiff);
    
    
    % Thresholding
    frameSize = size(frameDiff);
    for j=1:frameSize(1)
        for k=1:frameSize(2)
            % Noise filter with flat value
            if frameDiff(j,k) > 0.05
                % set value to 255
                frameInUse(j,k) = 255;
            else
                % set value to 0
                frameInUse(j,k) = 0;
            end
        end
    end
    
    
    
    % subplot(121);
    % imshow(t,[])
    
    % Remove objects with an area less than minSize
    t = bwlabel(frameInUse);
    minSize = 1000;
    for k = 1:max(t(:))
        a = t == k;
        if sum(a(:)) < minSize
            t(t==k) = 0;
        end
    end
    
    topened = imopen(t,strel('disk',5));
    t = topened;
    teroded = imerode(topened,strel('disk',5));
    t = teroded;
    imshow(topened,[])

    % subplot(1,2,2);
    % imshow(t,[])
    
    totalX = 0;
    totalY = 0;
    count = 0;
    
    for n=1:500
        for m=1:1000
            if t(n,m) ~= 0
                totalX = totalX + m;
                totalY = totalY + n;
                count = count + 1;
            end
        end
    end
    
    centers(1,1) = round(totalX/count);
    centers(1,2) = round(totalY/count);
    
    centreCoordinates(counter,1) = centers(1,1);
    centreCoordinates(counter,2) = centers(1,2);
    counter = counter + 1;
    
    %     t = double(t);
    imshow(t)
%     imshow(frame)
    
    
    if isnan(centers(1,1)) || isnan(centers(1,2))
        display('No Circles')
    else
        
        distance1 = 0;
        for n=centers(1,1):-1:1
            if t(centers(1,2), n) ~= 0
                distance1 = distance1 + 1;
            end
        end
        
        distance2 = 0;
        for n=centers(1,1):1000
            if t(centers(1,2), n) ~= 0
                distance2 = distance2 + 1;
            end
        end
        
        distance3 = 0;
        for n=centers(1,2):-1:1
            if t(n, centers(1,1)) ~= 0
                distance3 = distance3 + 1;
            end
        end
        
        distance4 = 0;
        for n=centers(1,2):500
            if t(n, centers(1,1)) ~= 0
                distance4 = distance4 + 1;
            end
        end
        
        radii = round((distance1 + distance2 + distance3 + distance4)/4);
        
%         imshow(t)
        viscircles(centers, radii,'EdgeColor','b');
        
    end
    
    %% Draw blue outlines on the circles
    
    % Find number of circle centers
    %     b = numel(centers);
    %     numOfCircles = b / 2;
    %
    %     viscircles(centers, radii,'EdgeColor','b');
    %
    %     frameNumbers(counter,:) = i;
    %
    %     if(numOfCircles > 0)
    %         centreCoordinates(counter,:) = centers;
    %     end
    %     counter = counter + 1;
    
end

%% Manipulate Data for better graph
% Find all the zeros in the matrix
matrixDimensions = size(centreCoordinates);

zeroCount = 0;

for c=1:matrixDimensions(1)
    if centreCoordinates(c,1) == 0 || isnan(centreCoordinates(c,1))
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
for e=1:matrixDimensions(1)
    if centreCoordinates(e,2)*percentageDiff < centreCoordinates(e+1,2)
        linecut = e;
        break;
    end
end

centresForLine = centreCoordinates(1:e,:);
matrixDimensions = size(centreCoordinates);


%% Measure success rate of algorithm

numOfPossibleFrames = floor(V.NumberOfFrames/frameIncrementSize);

successRate = (matrixDimensions(1)/numOfPossibleFrames) * 100


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
    


