clear
clc
close all

load testimg

centers = zeros(1,2);

minSize = 1000;

framehNew = imcrop(framehNew, [0 0 1000 500]);

t = bwlabel(framehNew);

% subplot(121);
% imshow(t,[])

for k = 1:max(t(:))
    a = t == k;
    if sum(a(:)) < minSize
        t(t==k) = 0;
    end
end

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

t = double(t);

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

imshow(t)
viscircles(centers, radii,'EdgeColor','b');
            

topened = imopen(t,strel('disk',15));
imshow(topened,[])

% imshow(imopen(t,strel('disk',15)),[])

% d = imdistline % Creates moveable line to measure distances
teroded = imerode(topened,strel('disk',5));

imshow(teroded,[])

[centers, radii, metric] = imfindcircles(teroded, [30 60], 'ObjectPolarity', 'bright');






