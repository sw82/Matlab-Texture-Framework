%Returns a rotation invariant LBP (uniform patterns) histogram (10 bins) of picture X.
%the size of picture X must be at least 3x3 pixels

function [hst binNum] = Feature_LBP_81(X)

% rgb = imread('fabric.png');
% X = rgb2gray(rgb);

patternMap = [1 2 2 3 2  10 3 4 2 10  10 10 3 10 4  5 2 10 10 10  10 10 10 10 3  10 10 10 4 10  5 6 ...
	2 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 3 10  10 10 10 10 10  10 4 10 10 10  5 10 6 7 ...
	2  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 ... 
	3 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 4 10 10  10 10 10 10 10  5 10 10 10 6  10 7 8 ...
	2 3  10 4 10 10 10  5 10 10 10 10  10 10 10 6 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 7 ...
	10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 10 10  10 8 ...
	3 4 10  5 10 10 10 6  10 10 10 10 10  10 10 7 10 10  10 10 10 10 10  10 10 10 10 10  10 10 10 8 ...
	4  5 10 6 10 10  10 7 10 10 10  10 10 10 10 8  5 6 10 7 10  10 10 8 6 7  10 8 7 8 8 9];

w1 = (1/sqrt(2))^2;
w2 = (1-1/sqrt(2))*(1/sqrt(2));

D = size(X);
sy = D(1);
sx = D(2);

Xi = zeros(sy+2,sx+2);
Xi(2:sy+1,2:sx+1) = X;

Xi1 = zeros(sy+2,sx+2);
Xi2 = zeros(sy+2,sx+2);
Xi3 = zeros(sy+2,sx+2);
Xi4= zeros(sy+2,sx+2);
Xi5 = zeros(sy+2,sx+2);
Xi6 = zeros(sy+2,sx+2);
Xi7 = zeros(sy+2,sx+2);
Xi8 = zeros(sy+2,sx+2);

p1 = zeros(sy+2,sx+2);
p2 = zeros(sy+2,sx+2);
p3 = zeros(sy+2,sx+2);
p4 = zeros(sy+2,sx+2);
p5 = zeros(sy+2,sx+2);
p6 = zeros(sy+2,sx+2);
p7 = zeros(sy+2,sx+2);
p8 = zeros(sy+2,sx+2);
p9 = zeros(sy+2,sx+2);

% LB   B   RB
p1(3:sy+2,3:sx+2) = X ;  % right bottom -> left top
p2(3:sy+2,2:sx+1) = w2*double(X) ; % bottom -> top
p3(3:sy+2,1:sx) = X ; % left bottom -> right top

%    L   C   R
p4(2:sy+1,3:sx+2) = w2*double(X) ; % right -> left
p5(2:sy+1,2:sx+1) = (1-1/sqrt(2))^2*double(X) ; % itself
p6(2:sy+1,1:sx) = w2*double(X) ; % left -> right

% LT    T   RT
p7(1:sy,3:sx+2) = X ; % right top -> left bottom
p8(1:sy,2:sx+1) = w2*double(X) ; % top -> bottom
p9(1:sy,1:sx) = X ; % left top -> right bottom

% 8 directions
% LT    T   RT
%    L   C   R
% LB   B   RB
% LT - left top; RT - right top; LB - left bottom; RB - right bottom
Xi1 = w1*p1+ p2+p4 + p5 + 0.000001; %Xi1 to the right and down from X
Xi2(3:sy+2,2:sx+1) = X;
Xi3 = w1*p3 + p2 + p6 + p5 + 0.000001;
Xi4(2:sy+1,1:sx) = X;
Xi5 = w1*p9 + p8 + p6 + p5 + 0.000001;
Xi6(1:sy,2:sx+1) = X;
Xi7 = w1*p7 + p8 + p4 + p5 + 0.000001;
Xi8(2:sy+1,3:sx+2) = X;

Xi= (Xi4>=Xi)+2*(Xi5>=Xi)+4*(Xi6>=Xi)+8*(Xi7>=Xi)+16*(Xi8>=Xi)+32*(Xi1>=Xi)+64*(Xi2>=Xi)+128*(Xi3>=Xi);

X=Xi(3:sy,3:sx);

x=0:255;

n=hist(X,x);

thst=sum(n');
hst=zeros(1,10);

for I=1:256
  	hst(patternMap(I))=hst(patternMap(I))+thst(I);
end

binNum = 10;
