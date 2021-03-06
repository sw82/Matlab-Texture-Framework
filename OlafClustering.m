function [  ] = OlafClustering(texturedatabase, dimension, output)
% OLAFCLUSTERING is a clustering algorithm without a predefined amount of
% cluster

%   "... Die Suche beginnt beispielsweise in der linken oberen Ecke
% eines 2D-Merkmalsraumes und wird systematisch fortgesetzt.
% So stoesst man irgendwann auf den ersten Lernvektor im -raum. Er bildet
% das Zentrum der 1. Klasse. Der naechste Lernvektor besitzt einen Abstand
% zu diesem Zentrum.
% Liegt er unterhalb einer Zurueckweisungsdistanz, so gehoert er zur selben
% Klasse. Diese einfache Suche setzt sich fort bis zu einem Lernvektor,
% dessen Distanz zum Zentrum der 1. Klasse die schon erwaehnte
% Zurueckweisungsdistanz ueberschreitet. Dann wird eine neue Klasse mit
% einem neuen Zentrum gegruendet. Da nun schon 2 Klassen existieren,
% muss die Distanz der noch folgenden Lernvektoren jeweils zu den beiden
% Klassenzentren berechnet werden. In gleicher Weise verfaehrt man weiter,
% bis saemtliche Lernvektoren zugeordnet sind. ..."

%% SOURCE:
%       Hochmuth O.: Mustererkennung, Uebungsaufgabe 36,
%       http://www.informatik.hu-berlin.de/~hochmuth/download/uebgsv2.shtml
%       12.04.2005

%% Changelog:
%               [23.03.11]   - Multidimension
%               [20.03.11]   - Bug fixed (b=a+1:length(dist))
%                            - deleted old functions, added 3d+ support,
%                            - removed old parameters and kicked brainz
%               [10.03.11]   - Something...
%               [22.02.11]   - Redesign


load(char(texturedatabase));

%% Change the current folder to the folder of this m-file
if(~isdeployed)
    cd(fileparts(which(mfilename)));
end

load(char(texturedatabase));%load database
[numImage numFeatures] = size(values);% get number of images and features present
allClusHeader = cell(1,1);
allClusValues = zeros(numImage,1);
pos = 0;%keeps track of position for the final result variable


%Generate the value vector (dimension independant)
%Generating current pair (n-dimensional)
%          startPos = i;
%        vector = dimensionRobot(dimension, values, startPos);


for i = 1:numFeatures
    if(i+1>numFeatures)
        break
    end
    
    for coljump=i+1:numFeatures
        pos = pos +1;
        
        %bei 3d kommt hier noch ne sufe dazu, bei 4d, noch eine usw.
        %         for coljump=i+1:numFeatures
        v(:,1)  = values(:,i);
        v(:,2)  = values(:,coljump);
        
        dist = createDistanceMatrix(v);
        
        zwd = calculateZWD(dist);
        
        cluster = generateCluster(dist, zwd);
        
        %store all cluster in allClus
        featureString = strcat(header(i), '/', header(coljump)); % concats the current two features
        allClusHeader(1,pos) = featureString;
        allClusValues(:,pos) = cluster;
    end
end





% And finally save those values
allClusClass(:,1) = class(:,:);
save (output, 'allClusHeader', 'allClusValues', 'allClusClass');

end

function recu(dim)


% abbruch: x = length und y auch

if dim == 0
    
else
    a = dim;    
    for b=a+1:numFeatures
        pos = pos +1;  
        
        v(:,1)  = values(:,a);
        v(:,2)  = values(:,b);
        
        dist = createDistanceMatrix(v);        
        zwd = calculateZWD(dist);        
        cluster = generateCluster(dist, zwd);       
        
        
        featureString = strcat(header(i), '/', header(coljump)); % concats the current two features
        allClusHeader(1,pos) = featureString;
        allClusValues(:,pos) = cluster;
        
        
        recu(dim-1)
    end
end

end

%
%
% [a b] = size(vector);
%
% switch dimension
%     case 1
%         return;
%     case 2
%
%         % Now move
%         % for each feature...
%         for i = 1:numFeatures
%             if(i+1>numFeatures)
%                 break
%             end
%             valA = vector(:,i);
%             for coljump=i+1:numFeatures
%                 pos = pos +1;
%                 valB= vector(:,coljump);
%
%                 dist = createDistanceMatrix(vector);
%
%                 % Calculate the Zurueckweisungsdistanz ;)
%                 zwd = calculateZWD(dist);
%
%                 % Generate Cluster
%                 %                 cluster = generateCluster(dist, zwd, numImage, valA, valB);
%                 cluster = generateCluster(dist, zwd);
%
%                 %store all cluster in allClus
%                 featureString = strcat(header(i), '/', header(coljump)); % concats the current two features
%                 allClusHeader(1,pos) = featureString;
%                 allClusValues(:,pos) = cluster;
%             end
%         end
%         allClusClass(:,1) = class(:,:);
%
%     case 3


%
%
% for i = 1:numFeatures
%     if(i+1>numFeatures)
%         break
%     end
%     valA = values(:,i);
%     for coljump=i+1 :numFeatures
%         valB= values(:,coljump);
%         for coljump2=coljump+1:numFeatures
%             valC= values(:,coljump2);
%             pos = pos +1;
%
%             % Create distance Matrix
%             %                     dist = createDistanceMatrix(numImage, valA, valB, valC);
%             dist = createDistanceMatrix(vector);
%             % Calculate the Zurueckweisungsdistanz ;)
%             zwd = calculateZWD(dist);
%
%             % Generate Cluster
%             cluster = generateCluster(dist, zwd, numImage);
%
%             %store all cluster in allClus
%             featureString = strcat(header(i), '/', header(coljump), '/', header(coljump2));
%             allClusHeader(1,pos) = featureString;
%             allClusValues(:,pos) = cluster;
%         end
%     end
% end
% allClusClass(:,1) = class(:,:);

% end




function [result]= dimensionRobot(dim, values,sp, v)

[numImage numFeatures] = size(values);
if nargin == 3
    a = dim + 1 - sp;
    a = sp + dim -1;%startposition + dimension
else
    a = dim;
end


%Exit criteria
% if (dim == 0)
% if (a == 0)
if(sp==a)
    v(:,a) = values(:,a);
    result = v;
    %now 'v' contains all vectors
    %      dist = createDistanceMatrix(numImage, v);
    return;
    
end

% result(:,dim) = values(:,dim);
v(:,a) = values(:,a);
%v(:,dim) = values(:,dim);
% Create distance Matrix
% result = dimensionRobot(dim-1, values,sp, v);
result = dimensionRobot(a-1, values, sp, v);
end



function [zwd] = calculateZWD(dist)
% CALCULATEZWD calculates the Zureuckweisungsdistanz (zwd)
% first try: mean

% [VERIFIED]
[rows cols] = size(dist);
cunt = 0;
summa = 0;
for k=1:rows
    for l=k+1:cols
        if isnan(dist(k,l))
        else
            summa = summa + dist(k,l);
            cunt = cunt + 1;
        end
    end
end
% V1: summa/cunt;       11/24
% V2: mean(realsum);    1/24
% V3: realsum/cunt;
realsum = sum(sum(dist));
zwd = realsum/cunt;
zwd   = summa/cunt;
% zwd = realsum/cunt;
end


%% function [dist] = createDistanceMatrix(X, Y )
function [dist] = createDistanceMatrix(V)
% CREATEDISTANCEMATRIX creates a matrix and gather all distance values
% CREATEDISTANCEMATRIX(numImage, ValX, ValY, ValZ)

%create empty distance matrix
[numImage dim] = size(V);
dist = zeros(numImage, numImage);

% v1 = V(1,1) or V(1,1,1)...and so on for each dimension
% v2 = V(2,2) or V(2,2,2)

for a=1:numImage
    for b=a+1:numImage
        zw =0;
        %         x=V(a,:); -> x(1), x(2)
        %         y=V(b,:); -> y(1), y(2)
        
        for d=1:dim
            %         (  x1   -    y1 )^2
            zw = zw + (V(a,d) - V(b,d))^2;
        end
        dist(a,b) = sqrt(zw);
    end
end %for all images

end %function


%% Generate cluster
function [cluster] = generateCluster(dist, zwd)
%create cluster array and put all to cluster 1
cluster=zeros(length(dist),1);

klaus = zeros(length(dist),1); % Klaus is for clusters, so we need exactly #images classes
klaus(1) = 1;%first object will always be the first center
center = zeros(1,1);
center(1) = 1; %just tells which (in the following) i is already a center

for i=2:length(dist)%begin with the second and iterate over all (X Y)
    
    found = false;
    
    %Check for all cluster center, where the new datapoint belongs to
    for	j=1:length(center)
        currentcenter = center(j);
        numberOfCenter = length(center);
        
        %so the current vector belongs to a group already clustered
        if (dist(currentcenter,i)	< zwd)%Zeile j, Spalte i
            %             if j == numberOfCenter %so no other centers left
            klaus(i) = currentcenter;
            found = true;
            
            % pass on, if the cluster was already determined
            %             % TODO: maybe a better solution here:
            %             % I mean the cluster can be already detemined, but what if it
            %             % wasn't the best we could do?
            %             else
            %                 %optimization: check for less distance towards all the other center
            %                 klaus(i) = currentcenter;
            %                 found = true;
            %
            %             end
        end
    end
    
    if (found == true)
        continue; %if we already found a cluster, go to the next iteration
        
        %does not match to any existing center
        %create a new cluster
    else
        klaus(i) = max(klaus + 1);
        center(length(center) + 1) = i;
    end
    
    
    
end


cluster = klaus;
end


