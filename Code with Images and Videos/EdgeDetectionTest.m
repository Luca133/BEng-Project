%% Test code for different edge detection algorithms
% By Luca Ricagni

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


%% Read frame and convert to greyscale

frame = read(V,200);
frame = rgb2gray(frame);

%% Run all the different algorithms

frame1=edge(frame,'sobel');
frame2=edge(frame,'prewitt');
frame3=edge(frame,'log');
frame4=edge(frame,'zerocross');
frame5=edge(frame,'Canny');
frame6=edge(frame,'approxcanny');

%% Plot all the techniques alongside each other

figure;
subplot(2,4,1),imshow(frame);
title('Greyscale image')
subplot(2,4,2),imshow(frame1);
title('Sobel filter')
subplot(2,4,3),imshow(frame2);
title('Prewitt filter')
subplot(2,4,4),imshow(frame3);
title('Log filter')
subplot(2,4,5),imshow(frame4);
title('Zerocross filter')
subplot(2,4,6),imshow(frame5);
title('Canny filter')
subplot(2,4,7),imshow(frame6);
title('Approxcanny filter')

figure;imshow([frame1 frame2 frame3;frame4 frame5 frame6])
line([0 3*1280],[720 720],'color','r')
line([1280 1280],[0 1440],'color','r')
line([2*1280 2*1280],[0 1440],'color','r')



[centers, radii, metric] = imfindcircles(frame, [36 60], 'ObjectPolarity', 'bright');
viscircles(centers, radii,'EdgeColor','b');





