
function [Laws] =  Feature_Laws(image,window)
%% Function: LawsTexture(image)
% http://sci.tech-archive.net/Archive/sci.image.processing/2007-05/msg00195.html

L5=[1 , 4 , 6 , 4 , 1]; %level  (Intensitaet)
E5=[-1, -2, 0 , 2 , 1]; %edge   (Kanten)
S5=[-1,  0, 2 , 0 ,-1]; %spot
R5=[1 , -4, 6 ,-4 , 1]; %ripple (Rauhheit)
W5=[-1, 2 , 0 , -2, 1]; %wave   (welligkeit)

% L7 =[ 1, 6, 15, 20, 15, 6, 1];
% E7=[-1, -4, -5, 0, 5, 4, 1];
% S7 =[-1, -2, 1, 4, 1, -2, -1];
% W7 =[-1, 0, 3, 0, -3, 0, 1];
% R7 =[1, -2, -1, 4, -1, -2, 1];
% O7 =[ -1, 6, -15, 20, -15, 6, -1];


% nach Handels besonders interessant: E5L5, E5S5, L5S5, R5R5

E5L5=E5'*L5;
E5S5=E5'*S5;
L5S5=L5'*S5;
R5R5=R5'*R5;

% L5E5=L5'*E5;
% L5R5=L5'*R5;
% R5L5=R5'*L5;
% S5E5=S5'*E5;
% S5S5=S5'*S5;
% S5L5=S5'*L5;
% E5E5=E5'*E5;
% E5R5=E5'*R5;
% R5E5=R5'*E5;
% S5R5=S5'*R5;
% R5S5=R5'*S5;

% figure;
Image=image;
d=window; % Window width
X=preprocess(Image, d);

%create a struct where to save Law's value to
% Laws = struct(  'L1', {{}}, 'L2', {{}}, 'L3', {{}}, 'L4', {{}}, ...
%     'L5', {{}}, 'L6', {{}}, 'L7', {{}}, 'L8', {{}}, ...
%     'L9', {{}}, 'L10', {{}},'L11', {{}}, 'L12', {{}}, ...
%     'L13', {{}}, 'L14', {{}}, 'L15', {{}});

% Laws = struct(  'L1', {{}}, 'L2', {{}}, 'L3', {{}}, 'L4', {{}});
Laws = struct(  );

for kernel = 1:4
    switch kernel
        case 1
            fk = conv2(double(X),double(E5L5));
        case 2
            fk = conv2(double(X),double(E5S5));
        case 3
            fk = conv2(double(X),double(L5S5));
        case 4
            fk = conv2(double(X),double(R5R5));
            
            % old ones, which may be not needed anymore
            %         case 1
            %             %Create the fk with use of convolution(X is the
            %             %preprocessed image)
            %             fk = conv2(double(X),double(L5E5));
            %
            %         case 2
            %             fk = conv2(double(X),double(E5L5));
            %         case 3
            %             fk = conv2(double(X),double(L5R5));
            %         case 4
            %             fk = conv2(double(X),double(R5L5));
            %         case 5
            %             fk = conv2(double(X),double(S5S5));
            %         case 6
            %             fk = conv2(double(X),double(R5R5));
            %         case 7
            %             fk = conv2(double(X),double(L5S5));
            %         case 8
            %             fk = conv2(double(X),double(S5L5));
            %         case 9
            %             fk = conv2(double(X),double(E5E5));
            %         case 10
            %             fk = conv2(double(X),double(E5R5));
            %         case 11
            %             fk = conv2(double(X),double(R5E5));
            %         case 12
            %             fk = conv2(double(X),double(S5R5));
            %         case 13
            %             fk = conv2(double(X),double(R5S5));
            %         case 14
            %             fk = conv2(double(X),double(E5S5));
            %         case 15
            %             fk = conv2(double(X),double(S5E5));
            
            
    end
    % Calculate texture energy maps.
    % m,n are dimensions of fk
    [m n] = size(fk);
    energyMap = Ek(fk, m, n);
    
    % Create temporary values to create the desired position
    l = 'L';
    n = num2str(kernel);
    pos = strcat(l,n);
    %save the energyMap to the struct
    %Laws.(pos) = energyMap;
    
    %compute mean
    appendix = 'mean';    
    pos2 = strcat(pos,appendix);    
    Laws.(pos2) = mean2(energyMap);
    
    
    %compute standard derivation
    appendix = 'std';
    pos2 = strcat(pos,appendix);
    Laws.(pos2) = std(std(energyMap));
    
    
    %compute standard derivation
    appendix = 'skewness';
    pos2 = strcat(pos,appendix);
    Laws.(pos2) = skewness(skewness(X));
    
      
    
    
    % Show the images. Make sure to add the [].
    % subplot(4, 4, kernel + 1);
    % imshow(energyMap, []);
end % of for loop.
return; % from LawsTexture()

function ek=Ek(fk,m,n)
%% Function: Ek(fk,m,n)
% Use fk to calculate texture energy map:
for i=8:m-7
    for j=8:n-7
        ek(i,j)=sum(sum(abs(fk(i-7:i+7,j-7:j+7))));
    end
end %eK

function prepimg=preprocess(Image,d)
%% Function: preprocess(Image,d)
% Preprocess a grayscale image (d is the window of preprocessing):
[m n]=size(Image);

prepimg=double(Image);
for j=1:d:m
    if j+d-1>m
        break;
    end
    for i=1:d:n
        if i+d-1>n
            break;
        end
        prepimg(j:j+d-1,i:i+d-1)=prepimg(j:j+d-1,i:i+d-1)- mean(mean(prepimg(j:j+d-1,i:i+d-1)));
    end
end
