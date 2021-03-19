%% Machine Vision code for final year project "Can machine vision improve efficiency in manufacturing?"
% This code finds the cargo at regular points in a video
% By Luca Ricagni

%% Clear

close all
clear
clc

%% Import video
%%%%%%%BEST VIDEOS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V = VideoReader('StageThreeWhite_Trim2.mp4'); % BEST WHITE ONE
% V = VideoReader('Stage3RedFinalNew2_Trim2.mp4'); % BEST RED ONE
% V = VideoReader('Stage3BlueBayLighting4_Trim.mp4'); % BEST BLUE ONE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stage one videos
% V = VideoReader('StageOneWhite.mp4');

% Stage two videos
% V = VideoReader('StageTwoRed.mp4');
% V = VideoReader('StageTwoWhite.mp4');
% V = VideoReader('StageTwoWhite2.mp4');

% Stage three videos
% V = VideoReader('StageThreeBlue.mp4');
% V = VideoReader('StageThreeRed.mp4');
V = VideoReader('StageThreeRed2.mp4');
% V = VideoReader('StageThreeWhite.mp4');
% V = VideoReader('StageThreeWhite_Trim2.mp4');
% V = VideoReader('StageThreeWhite2.mp4');
% V = VideoReader('StageThreeWhite3.mp4');

% Stage three new
% V = VideoReader('StageThreeRedNew.mp4');
% V = VideoReader('StageThreeRedNew2.mp4');
% V = VideoReader('StageThreeRedNew3.mp4'); % BEST NEW ONE
% V = VideoReader('StageThreeRedNew4.mp4');
% V = VideoReader('StageThreeBlueNew.mp4'); % WORKS MUCH BETTER BUT ISN'T A FULL VIDEO

% Stage three new new
% V = VideoReader('Stage3WhiteDark.mp4');
% V = VideoReader('Stage3BlueDark.mp4');
% V = VideoReader('Stage3WhiteSingleLight.mp4');
% V = VideoReader('Stage3RedSingleLight.mp4');
% V = VideoReader('Stage3BlueSingleLight.mp4');
% V = VideoReader('Stage3WhiteOrangeLight.mp4');
% V = VideoReader('Stage3RedOrangeLight.mp4');
% V = VideoReader('Stage3BlueOrangeLight.mp4');
% V = VideoReader('Stage3WhiteDoubleLight.mp4');
% V = VideoReader('Stage3RedDoubleLight.mp4');
% V = VideoReader('Stage3RedDoubleLight2.mp4');
% V = VideoReader('Stage3BlueDoubleLight.mp4');

% Stage three final
% V = VideoReader('Stage3BlueFinal.mp4'); % Works pretty well apart from bay

% None work
% V = VideoReader('CraneBayTest.mp4');
% V = VideoReader('CraneBayTest2.mp4');
% V = VideoReader('CraneBayTest3.mp4');
% V = VideoReader('CraneBayTest1Light.mp4');

%Bad
% V = VideoReader('Stage3BlueFinalNew.mp4');
% V = VideoReader('Stage3RedFinalNew.mp4');
% V = VideoReader('Stage3WhiteFinalNew.mp4');

% V = VideoReader('Stage3BlueFinalNew2.mp4'); % Bad


% V = VideoReader('Stage3RedFinalNew2.mp4'); % Found all along belt and briefly in bay
% V = VideoReader('Stage3RedFinalNew2_Trim2.mp4'); % BEST RED ONE

% V = VideoReader('Stage3WhiteFinalNew2.mp4');

% V = VideoReader('Stage3BlueMultiLight.mp4');
% V = VideoReader('Stage3RedMultiLight.mp4');

% V = VideoReader('Stage3BlueBigLight.mp4');
% V = VideoReader('Stage3BlueBigLight2.mp4');
% V = VideoReader('Stage3RedBigLight.mp4');

% V = VideoReader('Stage3BlueBigLightMoved.mp4');
% V = VideoReader('Stage3RedBigLightMoved.mp4');

% V = VideoReader('Stage3BlueBigLightMoved2.mp4');
% V = VideoReader('Stage3RedBigLightMoved2.mp4');

% V = VideoReader('Stage3BlueBayLighting.mp4');
% V = VideoReader('Stage3BlueBayLighting2.mp4');
% V = VideoReader('Stage3BlueBayLighting3.mp4');

% BEST BLUE ONE
% V = VideoReader('Stage3BlueBayLighting4.mp4'); % Found everywhere other than the very start
% V = VideoReader('Stage3BlueBayLighting4_Trim.mp4'); % BEST BLUE ONE



%% Declare variables (these can potentially be edited)

percentageDiff = 1.1; % Difference you look for to decide what data to use for line of best fit

timeInterval = 0.5; % Interval for frames in seconds

%% Declare other variables

frameIncrementSize = round((V.NumberOfFrames/V.Duration)*timeInterval); % Calculate frames per 0.5seconds

a = round(V.NumberOfFrames/frameIncrementSize); % Calculates how many values to store

centreCoordinates = zeros(a,2); % Initialise matrix to store centre coordinates

frameNumbers = zeros(a,1); % Initialise matrix to store the frame numbers

counter = 1; % Used in for loop

imageScaleFactor = 0.5;


%% Loop to go through image in specified increments
for i=1:frameIncrementSize:V.NumberOfFrames
%     pause(1)
    frame = read(V,i);
%     frame = rgb2gray(frame);
    %     frame = rgb2hsv(frame);
    %     frame = frame(:,:,1);
    
    frame = imresize(frame,imageScaleFactor); % Resizes based off scale factor

    
    imshow(frame);
    
    %% Find the cargo (if it is there) using Hough Circle Transform
    
%     [centers, radii, metric] = imfindcircles(frame, [36 60], 'ObjectPolarity', 'bright');
    
    [centers, radii, metric] = imfindcircles(frame, [20 40], 'ObjectPolarity', 'bright');

    
    % d = imdistline % Creates moveable line to measure distances
    
    %% Draw blue outlines on the circles
    
    % Find number of circle centers
    b = numel(centers);
    numOfCircles = b / 2;
    
    viscircles(centers, radii,'EdgeColor','b'); % Draws the blue outlines on
    
    frameNumbers(counter,:) = i;
    
    if(numOfCircles > 0)
        centreCoordinates(counter,:) = centers; % Stores centre coordinates
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



