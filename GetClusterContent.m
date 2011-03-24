function [ values ] = Cl_GetClusterContent( path, file, se, searchstring )
%GETCLUSTERCONTENT returns an array of all seachstring sub values
%   Detailed explanation goes here
mainFolder = dir(path);
completeFile = strcat(file, se); %e.g. 'S.mat' (stored data)

for i=1:length(mainFolder) %iterate through the whole folder
    % only go inside if it is a directory
    if (mainFolder(i).isdir & (mainFolder(i).name ~= '.') & (mainFolder(i).name ~= '..') )
        %which path we are operating on
        innerPath    = strcat(path, '/', mainFolder(i).name); %e.g. 'Tablare/1'
        subFolder = dir(innerPath);
        for j=1:length(subFolder)
            %if we found a .mat file
            if (strcmp(subFolder(j).name, completeFile))
                %load file
                S = load(strcat(innerPath,'/',completeFile));
                
                values = extractValues(S);
                break
            end
        end
%         n = str2double(S.number);
%         if (isLaws)
%             data(n).values = esd;
%             structure(n) = length(esd);
%         else
%             
%             data(n).values = da;
%             structure(n) = length(da);
%         end
        
    end
end

end


%% Function extractValues
function [values] = extractValues(S)
parts   = regexp(c1,'\.','split'); %extract parts of c1 (desired content)
parts2  = regexp(c2,'\.','split'); %extract parts of c2 (desired content)


if (length(parts)>=2 && length(parts2)>=2) % both have two parts in their name
    for x=1:length(S);
        if S(x).determined == false
            a= getfield(S(x),char(parts(1)), char(parts(2)));
            b= getfield(S(x),char(parts2(1)), char(parts2(2)));
            switch length(a)
                case 1
                    innerData(x,1) = a;
                case 2
                    innerData(x,1) = a(1);
                    innerData(x,2) = a(2);
                otherwise
                    return;
            end
            
            switch length(b)
                case 1
                    innerData(x,2) = b;
                case 2
                    innerData(x,1) = b(1);
                    innerData(x,2) = b(2);
                otherwise
                    return;
            end
            
            %
            %              innerData(x,1) = getfield(S(x),char(parts(1)), char(parts(2)));
            %              innerData(x,2) = getfield(S(x),char(parts2(1)), char(parts2(2)));
        else
            innerData(x,:) = 0;
        end
    end
else
    for x=1:length(S);
        if S(x).determined == false
            innerData(x) = getfield(S(x),content);
        else
            innerData(x,:) = 0;
        end
        
    end
end
end


