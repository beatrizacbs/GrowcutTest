image = imread('mdb010.bmp');
subplot(2, 2, 1);
imshow(image);
subplot(2, 2, 2);
imadjust(image);
imshow(image);
subplot(2, 2, 3);
imadjust(image);
imshow(image);