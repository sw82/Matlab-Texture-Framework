function [S] = CreateROI( path, file, coordinates, bwThresh )
%%  CreateROI will create all sub picures.
% + S(x).Picture
% + S(x).PictureGray 
% + S(x).BW    
% + S(x).Label   
% Finally a struct S is saved in the corresponding foler.
%
% Changelog:    - no offset for the margin anymore (size of roi = picture
%               size now)

%% Concat
document    = strcat(path, file);
roiName        = '_ROIPosition';
roiFile        = strcat(path, roiName, '.jpg');

%% Do check
if ~exist(document, 'file')% || ~exist(coordinates,'file')
    clc, clear
    disp('Either the document or your coordinates does not exist. Please check.')
    return
end

%% Read the image and coordinates and put it in a struct, close the file finally
img = imread(document);

%preallocation S
ll = length(coordinates);
% S(1:ll,1:ll)=zeros;


for ab=1:ll
    % Get stuff out of tline
    S(ab).Coordinates = coordinates(ab,:); % xmin ymin width height    
    % Keep track of the specified region
    S(ab).Name = ab;
end

%% Create ROIs and a summary map
% colors = ['y'; 'm'; 'c'; 'r'; 'g'; 'b'; 'w'; ]; %create color spec for colored visualization
% get image size
[xI yI zI]=size( img );
% and create an empty image
stitchedImage(xI,yI,zI)=1;

for x=1:length(S)
    % Create a ROI for a given coordinate
    
    
    %% Create a standalone picture according to its coordinates
    % required format: (ymin:ymax,xmin:xmax,:)
    % given format in S(x) [xmin ymin width height]
    
    %picsize = S(x).Coordinates(3) * S(x).Coordinates(4);
%     hoffset = S(x).Coordinates(4) * 0.05; % 0.05 height offset %
%     woffset = S(x).Coordinates(3) * 0.05; % 0.05 width offset %
     ymin = S(x).Coordinates(2);
     ymax = S(x).Coordinates(2) + S(x).Coordinates(4);
     xmin = S(x).Coordinates(1);
     xmax = S(x).Coordinates(1) + S(x).Coordinates(3);
     pictureRegion = img(ymin:ymax,xmin:xmax,:);
    
    S(x).Picture = pictureRegion;
    
    rgbImage = pictureRegion; % Actual image is the rgbImage
    S(x).PictureGray    = rgb2gray(rgbImage);
    S(x).BW             = im2bw(S(x).PictureGray, bwThresh);
    S(x).Label          = file;
     
    
    
    if (exist(roiFile, 'file')==0)
        % Make an annotation
        im = pictureRegion;
        
        [xm ym temp]=size(im);
        posy = (xm/2)-10;%(xmax+xmin)/2;
        %
        posx = (ym/2)+10;%(ymax+ymin)/2;
        hf = figure('color','white','units','normalized','position',[.1 .1 .8 .8]);
        %image(ones(size(im)));
        set(gca,'units','pixels','position',[5 5 size(im,2)-1 size(im,1)-1],'visible','off')
        
        text('units', 'pixels','position',[posx posy],'fontsize',30, 'BackgroundColor',[.7 .9 .7],'string', {x});
        % Capture the text image
        % Note that the size will have changed by about 1 pixel
        tim = getframe(gca);
        close(hf)
        
        % Extract the cdata
        tim2 = tim.cdata;
        
        % Make a mask with the negative of the text
        tmask = tim2==0;
        
        % Place white text
        % Replace mask pixels with UINT8 max
        im(tmask) = uint8(000);%255);
        stitchedImage(ymin:ymax,xmin:xmax,:) = im;
    end
end

% Create an image which shows a summary of each ROI
if (exist(roiFile, 'file')==0)
    %S().stitchedImage = stitchedImage;
    saveOverview(roiFile, stitchedImage);
end


%fid = fopen(coordinates, 'r');


%% ROI stitched picture


%% Fill struct with the coordinates
% region = 0;
% while 1
%     tline = fgetl(fid);
%
%     if ~ischar(tline) || strcmp(tline, '-1')
%         break
%     end
%     region = region + 1;
%
%
%
%     % Get stuff out of tline
%     S(region).Coordinates = strread(tline); % xmin ymin width height
%
%     % Keep track of the specified region
%     S(region).Name = region;
% end
% fclose(fid);
end



function saveOverview(roiFile,image)
%% Create the whole path for the file
% name        = '_ROIPosition';
% file        = strcat(path, name, '.jpg');
roiFile        = char(roiFile);

%% Read the image and convert to gray image
%     X   = imread(image);

%% Save the image

imwrite(image, roiFile, 'jpg');


end