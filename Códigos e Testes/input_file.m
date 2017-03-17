pontos = fopen('pontos.txt', 'w');
image = imread('mdb002.bmp');
imshow(image);
points = 9;
[xd, yd] = ginput(points);
[xf, yf] = ginput(points);

for i = 1:points
    fprintf(pontos, '%d\f%d\n', round(xd(i)), round(yd(i)));
end

for i = 1:points
    fprintf(pontos, '%d\f%d\n', round(xf(i)), round(yf(i)));
end

fclose(pontos);