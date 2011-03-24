hits = size(allClusValues);
A = zeros(hits(1),1);
matchArr = cell(size(A));
groupArr = zeros(size(A));
minMatch = 25;

%acquire the number of max. hits
maxClass = max(max(allClusValues));

%when maxClass equals to [numLines, ~] = size(allClusValues) ignore this
%line

%compute # of hits
hitman = zeros(hits(1),hits(1));

tic

[numOfPictures, numOfFeatures]  = size(allClusValues);
numOfMatches = zeros(numOfPictures, numOfPictures);

for k=1:numOfPictures %iterate over all rows
    temp = 0; % create a temporary variable to store each hit
    
    for l=k+1:numOfPictures % now iterate over all rows beneath the current row
        %and check for each column
        for z=1:numOfFeatures
            
            % !!! IMPORTANT: Don't check those columns which don't have real
            % class separation. 
            % e.g. a column which has 100 entries from
            % 1...100\max(allClusValues(:,z))           
            if (max(allClusValues(:,z)) == numOfPictures)
               continue; 
            end
            
            %if both rows have a column (class) in common increase temp
            if  allClusValues(k,z) == allClusValues(l,z)
                temp = temp + 1;
            end
        end
        %here temp stores the amount of matches between those two pictures
        if (temp >= minMatch)
            hitman(l,k) = hitman(l,k) +1;
        end
        % the result will be a matrix which can be read in a triangular
        % shape, because the left half will always be 0 (from the diagonal
        % on)
        
        % THIS IS HOW YOU READ IT:
        % Picture ROW is in the same class as Picture COLUMN:
        % e.g. Picture 1 in row 1 is 59 times in the same class as Picture
        % 2, but only 24 times in the same class as Picture 3
        %
        %      C O L U M N 
        %    R 0    59    24    24     0     0     0    
        %    O 0     0    63    38     0     0     0    
        %    W 0     0     0    53     5     5     5    
        %      0     0     0     0    10    16    21    
        %      0     0     0     0     0    92    87    
        %      0     0     0     0     0     0    93           
        numOfMatches(k,l) = temp;        
        
        % reset temp and continue with the next picture
        temp =0 ;
    end
end

toc
 

for aa=1:hitman(1) % number of rows
    for bb=1:hitman(2) % so for each row now iterate through the whole column
        %         if(hitman(aa,bb) ==  maxClass)
        str = num2str(bb);
        if (cellfun('isempty',matchArr(aa)) == 1) %so the cell is empty
            matchArr(aa) = {str};
        else
            combinedStr = strcat(matchArr(aa),', ', str);
            matchArr(aa) = combinedStr;
        end
        if (groupArr(aa) ~= 0 || groupArr(bb) ~= 0 ) %if one of the pictures is already in one group
            if (groupArr(aa) ~= 0)%if the first is in
                group = groupArr(aa);
                groupArr(bb) = group;
            end
            if (groupArr(bb) ~= 0)%if the first is in
                group = groupArr(bb);
                groupArr(aa) = group;
            end
            
        else %insert the two pictures in the next available group and therefore create a new group
            nextGroup = max(groupArr) +1;
            groupArr(aa) = nextGroup;
            groupArr(bb) = nextGroup;
        end
        %         end
    end
end
