function [ values ] = Cl_GetClusterContent( path, file, se, searchstring )
%GETCLUSTERCONTENT returns an array of all seachstring sub values
%   This method extracts all subfeatures of a given searchstring.
mainFolder = dir(path);
completeFile = strcat(file, se); %e.g. 'S.mat' (stored data)

for i=1:length(mainFolder) %iterate through the whole folder
    % only go inside if it is a directory
    %      if ((mainFolder(i).name ~= '.') & (mainFolder(i).name ~= '..') )
    
    if (strcmp(num2str(mainFolder(i).name), '.')~=1 ) % and then, only if it's a real folder
        if (strcmp(num2str(mainFolder(i).name), '..')~=1 ) % and then, only if it's a real folder
            %which path we are operating on
%             innerPath    = strcat(path, '/', mainFolder(i).name); %e.g. 'Tablare/1'
%             subFolder = dir(innerPath);
%             for j=1:length(subFolder) % iterate through the subfolder (the innerPath)
                
                if (strcmp(num2str(mainFolder(i).name), completeFile)==1 )%if we found a .mat file
                    %load the file
                    S = load(strcat(path,'/',completeFile));
                    
                    % structure contains all fields of the stored struct
                    % e.g. Coordinates, Name, Picture, isEmpty, etc.
                    structure = getfield(S,'S');
                    
                    % inner only holds all values related to the searchstring
                    inner = getfield(structure, searchstring);
                    
                    % values contains all different values for the searchstring
                    values = fieldnames(inner);
                    
                    break
                end
%             end
            %Added, because if we have already found our values, we don't need
            %to proceed
%             if isempty(values) == 0
%                 break;
%             end
        end
    end
end
end