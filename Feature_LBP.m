function [ hst binNum ] = Feature_LBP( X )
%LBP Local Binary Partition
% LBP Measure: Jedem Pixel P wird ein Byte b1b2b3b4b5b6b7b8 zugeordnet
%       1,	falls k?ter Nachbar > P
%       0, sonst
%
%       STRUCTURE:
%
%               |   1              2            3; |
%               |   8             LBP           4; |
%               |   7              6            5; |
%
%     msk=    [   pR(r-1,c-1) pR(r-1,c)   pR(r-1,c+1) ;
%                 pR(r,c-1)   pR(r,c)     pR(r, c+1);
%                 pR(r+1,c-1) pR(r+1,c)   pR(r+1,c+1);    ];
%
% Ein Histogramm der Bytes einer Region beschreibt deren Textur
%
% CHANGELOG:    xx.xx.2010 creation
%               20.01.2011 reanimated

%% Local Binary Partition
tic


% rgb = imread('fabric.png');
% X = rgb2gray(rgb);

% image size
D = size(X);
sx = D(2);
sy = D(1);

% central pixels
Xi = zeros(sy+2,sx+2);
Xi(2:sy+1,2:sx+1) = X;

% 8 directions 
% hN = [0 1 0; 0 -1 0; 0 0 0];
% hS = [0 0 0; 0 -1 0; 0 1 0];
% hE = [0 0 0; 0 -1 1; 0 0 0];
% hW = [0 0 0; 1 -1 0; 0 0 0];
% hNE = [0 0 1; 0 -1 0; 0 0 0];
% hSE = [0 0 0; 0 -1 0; 0 0 1];
% hSW = [0 0 0; 0 -1 0; 1 0 0];
% hNW = [1 0 0; 0 -1 0; 0 0 0];

Xi1 = zeros(sy+2,sx+2);
Xi2 = zeros(sy+2,sx+2);
Xi3 = zeros(sy+2,sx+2);
Xi4= zeros(sy+2,sx+2);
Xi5 = zeros(sy+2,sx+2);
Xi6 = zeros(sy+2,sx+2);
Xi7 = zeros(sy+2,sx+2);
Xi8 = zeros(sy+2,sx+2);

% LT    T   RT
%    L   C   R
% LB   B   RB
% LT - left top; RT - right top; LB - left bottom; RB - right bottom

% right bottom -> left top
Xi1(3:sy+2,3:sx+2) = X;
% bottom -> top
Xi2(3:sy+2,2:sx+1) = X;
% left bottom -> right top
Xi3(3:sy+2,1:sx) = X;
% left -> right
Xi4(2:sy+1,1:sx) = X;
% left top -> right bottom
Xi5(1:sy,1:sx) = X;
% top -> bottom
Xi6(1:sy,2:sx+1) = X;
% top right -> left bottom
Xi7(1:sy,3:sx+2) = X;
% right -> left
Xi8(2:sy+1,3:sx+2) = X;

% calculate the LBP value
Xi = (Xi1>=Xi)+2*(Xi2>=Xi)+4*(Xi3>=Xi)+8*(Xi4>=Xi)+16*(Xi5>=Xi)+32*(Xi6>=Xi)+64*(Xi7>=Xi)+128*(Xi8>=Xi);

X = Xi(3:sy,3:sx);

% calculate the hist on X (h??w)
% hist dimension is 256??w
hst1 = hist(X,0:255);
hst = sum(hst1');

binNum = 256;

% 
% %get the image size
% D  = size (S);
% sx = D(2);
% sy = D(1);
% 
% %figure out the central pixel
% Xi = zeros(sy+2, sx +2);
% Xi(2:sy+1,2:sx+1) = S;
% 
% 
% %8 directions
% Xi1 = zeros(sy+2,sx+2);
% Xi2 = zeros(sy+2,sx+2);
% Xi3 = zeros(sy+2,sx+2);
% Xi4= zeros(sy+2,sx+2);
% Xi5 = zeros(sy+2,sx+2);
% Xi6 = zeros(sy+2,sx+2);
% Xi7 = zeros(sy+2,sx+2);
% Xi8 = zeros(sy+2,sx+2);
% 
% % LT    T    RT
% % L     C    R
% % LB    B    RB
% 
% 
% 
% 
% %old code
% for x=1:length(S)
%     pR = S(x).Picture;
%     lbp = size(pR);% create new array and initialize for speed results
%     % S(x).LBP = size(pR);
%     for r=2:lbp(1)-2 % r = row %
%         for c=2:lbp(2)-2  %c = column %
%             neighbours = [pR(r-1,c-1); pR(r-1,c); pR(r-1,c+1); pR(r, c+1); pR(r+1,c+1); pR(r+1,c); pR(r+1,c-1); pR(r,c-1);];
%             
%             byte = [];
%             current = pR(r,c);
%             for i=1:length(neighbours)
%                 if (neighbours(i) > current)
%                     byte = horzcat(byte, '1');
%                 else
%                     byte = horzcat(byte, '0');
%                 end
%                 
%             end
%             A{(r),(c)} = byte(:)'; %str2num(byte);
%             
%         end
%     end
%     S(x).LBP = A; %str2num(dec2bin(pictureRegion(row,column), 8)); %create byte
%     % S(x).LBP = lbp;
% end
% toc
end

