function [cnt]= Main(folder, file, texturedatabase, cnt)
% Compute texture values for a given image.
%
% Changelog:
%               - [03.03.11] added Gabor feature (std, mean)
%               - [28.02.11] added support for orientation based
%               coordinates
%               - [14.02.11] added counter for image number
%               - [14.02.11] added feature and classification database
%               - added manual coordinates instead of reading it all the
%                  time from a file
%               - remove old .mat file before saving the new one and now
%                  only save the struct "S" and not the whole workspace


%% Parameters:
%coordfile = '../Samples/coordinates.txt';
coords =  [75 82 682 462; 949 160 450 306; 243 788 340 230; 1089 850 164 108];
coordsO = [189 98 448 664;1031 194 294 442;  1067 746 218 330;347 852 98 156];


bwThresh = 0.01; % Threshold to convert image into BW image

%% Introduction
% - clears variables
% - introduce product ;)
% - change folder to current .m file
% - print version/ toolboxes
% - check for image processing toolbox

%Intro();


%%Print current Folder
fprintf('\n');
fprintf('Current: %s%s \n', folder, file);
fprintf('\n');

%% Create document structure Tablare/X/testX.jpg
fprintf('Creating document structure... \n');
path        = folder;
document    = file;

%% Create ROI, and extract normal picure, grey picture and bw picture
fprintf('Creating ROI structure... \n');

%if rotation is either 90 or 270 degree, take different values, same with
%zoom
ne = findstr(document, 'O90');
ha = findstr(document, 'O270');
zo = findstr(document, 'Zoom');
if(~isempty(ne) || ~isempty(ha))
    S = CreateROI(path, document, coordsO, bwThresh);
    
else
    
    S = CreateROI(path, document, coords, bwThresh);
    
end


%load texture database
load(texturedatabase);


%% Call functions
fprintf('Computing Haralick features...\n');
fprintf('Computing LBP features...\n');
fprintf('Computing Gabor feature vector... \n');
fprintf('Computing Laws texture values... \n');

for x=1:length(S);
    
    %Compute values
    
    % Usage is similar to graycoprops() but needs extra parameter 'pairs' apart
    % from the GLCM as input
    
    %first angle
    GLCM2           = graycomatrix(S(x).PictureGray,'Offset',[2 0;0 2]);
    % The output is a structure containing all the parameters for the
    % different Haralick values
    S(x).Haralick   = Feature_GLCM(GLCM2,0);
    
    %     %second angle 135 degrees
    %     GLCM2           = graycomatrix(S(x).PictureGray,'Offset',[-1 -1;-1 -1]);
    %     S(x).Haralick135  = Feature_GLCM(GLCM2,0);
    %
    %     %third angle 0 degrees
    %     GLCM2           = graycomatrix(S(x).PictureGray,'Offset',[0 1;1 0]);
    %     S(x).Haralick0  = Feature_GLCM(GLCM2,0);
    %
    %     %fourth angle 45 degrees
    %     GLCM2           = graycomatrix(S(x).PictureGray,'Offset',[-1 1;1 -1]);
    %     S(x).Haralick45  = Feature_GLCM(GLCM2,0);
    %
    %     %fifth angle 90 degrees
    %     GLCM2           = graycomatrix(S(x).PictureGray,'Offset',[-1 0;0 -1]);
    %     S(x).Haralick90  = Feature_GLCM(GLCM2,0);
    %
    %%LBP
    % a LBP-based histogram (256 bins) of picture X
    [hst256 binNum256] = Feature_LBP(S(x).PictureGray);
    S(x).LBP.LBP256 = hst256;
    
    % visualize the histogram
    %figure, bar(1:binNum256, hst256, 'r'), title('256bins LBP hist');
    
    % a rotation invariant LBP (uniform patterns) histogram (10 bins) of picture X.
    [hst10 binNum10] = Feature_LBP_81(S(x).PictureGray);
    S(x).LBP.LBP10 = hst10;
    
    
    % a rotation invariant LBP (uniform patterns) histogram (18 bins) of picture X.
    [hst18 binNum18] = Feature_LBP_162(S(x).PictureGray);
    S(x).LBP.LBP18 = hst18;
    
    % a rotation invariant LBP (uniform patterns) histogram (26 bins) of picture X.
    [hst26 binNum26] = Feature_LBP_243(S(x).PictureGray);
    S(x).LBP.LBP26 = hst26;
    
    % LAWS
    S(x).Laws        = Feature_Laws(S(x).PictureGray,5);
    
    
    %Third feature....
    
    %http://www.mathworks.com/matlabcentral/fileexchange/5237-2d-gabor-filt
    %erver123
    %Gabor
    [G,gabout] = Feature_Gabor(S(x).PictureGray ,2,4,16,pi/3);
    Gab = struct();
    Gab.GStd = std2(gabout);
    Gab.GMean = mean2(gabout);
    
    S(x).Gabor = Gab;
    
    
    
    
    
    % SAVE SUBVALUES TO TEXTUREDATABASE
    %first find out in which line to save
    % --> now 'cnt' indicates the line number
    currentCol = 1; % indicates current column number
    
    fns = fieldnames(S(x).Haralick);
    %HARALICK
    if(cnt==1)
        header(currentCol:currentCol+length(fns)-1) = fns;
    end
    for fnnum=1:length(fns)
        v = getfield(S(x).Haralick, char(fns(fnnum)));
        values(cnt, currentCol) = v(1);
        currentCol = currentCol +1;
    end
    
    %     %HARALICK135
    %     if(cnt==1)
    %         header(currentCol:currentCol+length(fns)-1) = fns;
    %     end
    %     for fnnum=1:length(fns)
    %         v = getfield(S(x).Haralick135, char(fns(fnnum)));
    %         values(cnt, currentCol) = v(1);
    %         currentCol = currentCol +1;
    %     end
    %
    %     %HARALICK0
    %     if(cnt==1)
    %         header(currentCol:currentCol+length(fns)-1) = fns;
    %     end
    %     for fnnum=1:length(fns)
    %         v = getfield(S(x).Haralick0, char(fns(fnnum)));
    %         values(cnt, currentCol) = v(1);
    %         currentCol = currentCol +1;
    %     end
    %
    %     %HARALICK45
    %     if(cnt==1)
    %         header(currentCol:currentCol+length(fns)-1) = fns;
    %     end
    %     for fnnum=1:length(fns)
    %         v = getfield(S(x).Haralick45, char(fns(fnnum)));
    %         values(cnt, currentCol) = v(1);
    %         currentCol = currentCol +1;
    %     end
    %
    %     %HARALICK90
    %     if(cnt==1)
    %         header(currentCol:currentCol+length(fns)-1) = fns;
    %     end
    %     for fnnum=1:length(fns)
    %         v = getfield(S(x).Haralick90, char(fns(fnnum)));
    %         values(cnt, currentCol) = v(1);
    %         currentCol = currentCol +1;
    %     end
    
    % LAWS
    fns = fieldnames(S(x).Laws);
    if(cnt==1)
        header(currentCol:currentCol+length(fns)-1) = fns;
    end
    for fnnum=1:length(fns)
        v = getfield(S(x).Laws, char(fns(fnnum)));
        values(cnt, currentCol) = v(1);
        currentCol = currentCol +1;
    end
    
    
    %GABOR
    fns = fieldnames(S(x).Gabor);
    if(cnt==1)
        header(currentCol:currentCol+length(fns)-1) = fns;
    end
    for fnnum=1:length(fns)
        v = getfield(S(x).Gabor, char(fns(fnnum)));
        values(cnt, currentCol) = v(1);
        currentCol = currentCol +1;
    end
    
    
     
    %add class for the current image
    parts   = regexp(file,'_','split');
    class(cnt,1)=(parts(1));
    
    %add name, so it makes it easier to find values
    parts2  = regexp(file, '\.', 'split');
    name(cnt,1)=(parts2(1));
    
    %next image
    if (x < 4)
        cnt = cnt + 1;
    end
end

fprintf('Saving struct... \n');
str    = strcat(path, 'S', '.mat');

%Remove old .mat file
if (exist(str,'file')==2)
    delete(str);
end
%And save the new ones and our texturedatabase
save (str, 'S');
save (texturedatabase, 'values', 'class', 'header', 'name');

%
% fprintf('Freeing memory... \n');
% clear

fprintf('All done... \n');
return; %from Main


%%HELPER

%----------------------------------------------------------------------
% This function generate the spatial domain of the Gabor wavelets
% which are specified by number of scales and orientations and the
% maximun and minimun center frequency.
%
%         N : the size of rectangular grid to sample the gabor
%     index : [s,n] specify which gabor filter is selected
%      freq : [Ul,Uh] specify the maximun and minimun center frequency
% partition : [stage,orientation] specify the total number of filters
%      flag : 1 -> remove the dc value of the real part of Gabor
%             0 -> not to remove
%----------------------------------------------------------------------

function [Gr,Gi] = Gabor(N,index,freq,partition,flag)

% get parameters

s = index(1);
n = index(2);

Ul = freq(1);
Uh = freq(2);

stage = partition(1);
orientation = partition(2);

% computer ratio a for generating wavelets

base = Uh/Ul;
C = zeros(1,stage);
C(1) = 1;
C(stage) = -base;

P = abs(roots(C));
a = P(1);

% computer best variance of gaussian envelope

u0 = Uh/(a^(stage-s));
Uvar = ((a-1)*u0)/((a+1)*sqrt(2*log(2)));

z = -2*log(2)*Uvar^2/u0;
Vvar = tan(pi/(2*orientation))*(u0+z)/sqrt(2*log(2)-z*z/(Uvar^2));

% generate the spetial domain of gabor wavelets

j = sqrt(-1);

if (rem(N,2) == 0)
    side = N/2-0.5;
else
    side = fix(N/2);
end;

x = -side:1:side;
l = length(x);
y = x';
X = ones(l,1)*x;
Y = y*ones(1,l);

t1 = cos(pi/orientation*(n-1));
t2 = sin(pi/orientation*(n-1));

XX = X*t1+Y*t2;
YY = -X*t2+Y*t1;

Xvar = 1/(2*pi*Uvar);
Yvar = 1/(2*pi*Vvar);

coef = 1/(2*pi*Xvar*Yvar);

Gr = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*cos(2*pi*u0*XX);
Gi = a^(stage-s)*coef*exp(-0.5*((XX.*XX)./(Xvar^2)+(YY.*YY)./(Yvar^2))).*sin(2*pi*u0*XX);

% remove the real part mean if flag is 1

if (flag == 1)
    m = sum(sum(Gr))/sum(sum(abs(Gr)));
    Gr = Gr-m*abs(Gr);
end;
return;

% -----------------------------------------------------------------
% This function compute the image features for each Gabor filter
% output, it is used for PAMI paper.
% -----------------------------------------------------------------

function F = Fea_Gabor_brodatz(img,GW,N,stage,orientation)

A = fft2(img);

F = [];
z = zeros(1,2);

for s = 1:stage,
    for n = 1:orientation,
        D = abs(ifft2(A.*GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n)));
        z(1,1) = mean(mean(D));
        z(1,2) = sqrt(mean(mean((D-z(1,1)*ones(128,128)).^2)));
        F((s-1)*orientation+n,1:2) = z;
    end;
end;
return;

function [G1,G2,gabout1,gabout2] = gaborfilter(I,Sx,Sy,f,theta);

if isa(I,'double')~=1
    I = double(I);
end

for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        M1 = cos(2*pi*f*sqrt(x^2+y^2));
        M2 = cos(2*pi*f*(x*cos(theta)+y*sin(theta)));
        G1(fix(Sx)+x+1,fix(Sy)+y+1) = (1/(2*pi*Sx*Sy)) * exp(-.5*((x/Sx)^2+(y/Sy)^2))*M1;
        G2(fix(Sx)+x+1,fix(Sy)+y+1) = (1/(2*pi*Sx*Sy)) * exp(-.5*((x/Sx)^2+(y/Sy)^2))*M2;
    end
end

Imgabout1 = conv2(I,double(imag(G1)),'same');
Regabout1 = conv2(I,double(real(G1)),'same');

Imgabout2 = conv2(I,double(imag(G2)),'same');
Regabout2 = conv2(I,double(real(G2)),'same');

gabout1 = sqrt(Imgabout1.*Imgabout1 + Regabout1.*Regabout1);
gabout2 = sqrt(Imgabout2.*Imgabout2 + Regabout2.*Regabout2);


return;
