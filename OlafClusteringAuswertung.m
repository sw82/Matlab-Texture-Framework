function OlafClusteringAuswertung(tdb)
load(tdb);

%number of elements
[lengCount, ~]  = size(allClusClass);

%number of elements in the same class
numOfElems = 0;
resultClass  = cell(0);
resultHeader = allClusHeader;
resultResult = zeros(1,1);

%now iterate through
for i=1:lengCount
    
    %abbruchbedingung, if we are out of elements, break it baby
    if lengCount ==  i
        [resultResult,resultClass] = getValues(i,numOfElems, resultClass, resultResult, allClusValues, allClusClass,allClusHeader);
        break;
    end
    
    %do something as long as we are still in the same class
    if (strcmp(allClusClass(i), allClusClass(i+1)))
        numOfElems = numOfElems + 1;
    else
          [resultResult,resultClass] = getValues(i,numOfElems, resultClass, resultResult, allClusValues, allClusClass, allClusHeader);
        %reset numOfElements counter
        numOfElems = 0;
    end
end

%most hits
max(max(resultResult));



return;


function [resultResult,resultClass] = getValues(i,numOfElems,resultClass, resultResult, allClusValues, allClusClass, allClusHeader)
numOfElems = numOfElems + 1;
%now we know how many elements are supposed to be in one class
%figure out start and end of a certain group

start = i - (numOfElems) +1;
if start == 0
    start = 1;
end
ende = start + numOfElems -1;
% Determines the current class
currentClus = allClusValues(start:ende,:);

[~, featureCombos] = size(currentClus);

% Put the class name to the results
currentClusName = allClusClass(start);
resLen = length(resultClass);

resultClass(resLen+1,1) =currentClusName;


for featureCount=1:featureCombos
    % Current FeatureCombo
    currentFeature = allClusHeader(featureCount);
    currentFeatureClus = currentClus(:, featureCount);
    matches = getMatches(currentFeatureClus);
    resultResult(resLen+1, featureCount) = matches;
end

return;

function [out] = getMatches(currentFeatureClus)
% A given matrix with a number of elements.
% This method returns the most common element in the matrix .
% First sorting it and then counting.
result = currentFeatureClus;
result = sort(result);
aa = zeros(length(currentFeatureClus),2);
aa(:,1) = result;


for k=1:length(currentFeatureClus)
    current = aa(k,1);
    if aa(k,2) == 0
        if k>=2
            if current == aa(k-1,1)
                aa(k,2) = aa(k-1,2)  +1;
            else
                aa(k,2) = 1;
                
            end
        else
            aa(k,2) = 1;
        end
    end
end
out = max(aa(:,2));

return;

