fontSize = 20;
grayImage = rgb2gray(imread('03.jpg'));
grayImage1 = grayImage(:, : );
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);
% Display the original gray scale image.
subplot(3, 4, 1);
imshow(grayImage);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
set(gcf,'name','Image Viewer','numbertitle','off') 

% HPF
[m, n]=size(grayImage);
f_transform=fft2(grayImage);
f_shift=fftshift(f_transform);
p=m/2;
q=n/2;
d0=30;
for i=1:m
    for j=1:n
distance=sqrt((i-p)^2+(j-q)^2);
low_filter(i,j)=1-exp(-(distance)^2/(2*(d0^2)));
    end
end
filter_apply=f_shift.*low_filter;
image_orignal=ifftshift(filter_apply);
image_filter_apply=abs(ifft2(image_orignal));
% Display the image.
subplot(3, 4, 2);
imshow(image_filter_apply);
title('High Pass Filtered Image', 'FontSize', fontSize);

% MF
imflt=medfilt2(image_filter_apply, [11 11]);
% Display the image.
subplot(3, 4, 3);
imshow(imflt);
title('Median Filtered Image', 'FontSize', fontSize);

% Threshold segmentation 1
% Threshold the image to make a binary image.
thresholdValue = 100;
TS = grayImage > thresholdValue;
% Display the image.
subplot(3, 4, 4);
imshow(TS);
title('Binary image threshold value 100', 'FontSize', fontSize);


% Extract the outer blob, which is the skull.  
% The outermost blob will have a label number of 1.
labeledImage = bwlabel(TS);		% Assign label ID numbers to all blobs.
TS = ismember(labeledImage, 1);	% Use ismember() to extract blob #1.
% Thicken it a little with imdilate().
TS = imdilate(TS, true(0));
% Display the final binary image.
%subplot(3, 4, 10);
%imshow(TS);
%title('Binary image of Skull Alone', 'FontSize', fontSize);


% Mask out the skull from the original gray scale image.
skullFreeImage = grayImage; % Initialize
skullFreeImage(TS) = 0; % Mask out.
% Display the image.
subplot(3, 4, 5);
imshow(skullFreeImage);
title('Skull Free Image', 'FontSize', fontSize);


% Now threshold to find the tumor
thresholdValue = 150;
TS = skullFreeImage > thresholdValue;
% Display the image.
subplot(3, 4, 6);
imshow(TS);
title('Binary image threshold value 150', 'FontSize', fontSize);

% Assume the tumor is the largest blob, so extract it
binaryTumorImage = bwareafilt(TS, 1);
% Display the image.
subplot(3, 4, 7);
imshow(binaryTumorImage);
title('Tumor Alone', 'FontSize', fontSize);

% Find tumor boundaries.
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of the tumor over the original grayscale image using the coordinates returned by bwboundaries.
subplot(3, 4, 8);
imshow(grayImage, []);
axis on;
caption = sprintf('Tumor\nOutlined in red in the overlay'); 
title(caption, 'FontSize', fontSize, 'Color', 'r'); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
boundaries = bwboundaries(binaryTumorImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	% Note: since array is row, column not x,y to get the x you need to use the second column of thisBoundary.
	plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 2);
end
hold off;

% Now indicate the tumor a different way, with a red tinted overlay instead of outlines.
subplot(3, 4, 9);
imshow(grayImage, []);
caption = sprintf('Tumor\nSolid & tinted red in overlay'); 
title(caption, 'FontSize', fontSize, 'Color', 'r'); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
% Display the tumor in the same axes.
% Make a truecolor all-red RGB image.  Red plane has the tumor and the green and blue planes are black.
redOverlay = cat(3, ones(size(binaryTumorImage)), zeros(size(binaryTumorImage)), zeros(size(binaryTumorImage)));
hRedImage = imshow(redOverlay); % Save the handle; we'll need it later.
hold off;
axis on;
% Now the tumor image "covers up" the gray scale image.
% We need to set the transparency of the red overlay image to be 30% opaque (70% transparent).
alpha_data = 0.3 * double(binaryTumorImage);
set(hRedImage, 'AlphaData', alpha_data);

