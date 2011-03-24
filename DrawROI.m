function [  ] = DrawROI( file )
%DRAWROI just simply opens a picture, draws a mask and allows the user then
%to move the mask over the image and get the specific coordinates.
%   e.g. DrawROI('Brodatz/7/test7.jpg');
img = imread(file);
h_im = imshow(img);
e = imrect(gca,[55 10 120 120]);
BW = createMask(e,h_im);

end

