function [data, structure]=Cl_GetClusterData(path, file, c1, c2, se)
%CL_GETCLUSTERDATA will return all data from the saved S.mat's in the
% following folders: FOLDER/X/S.mat (content)

mainFolder = dir(path);
completeFile = strcat(file, se); %e.g. 'S.mat' (stored data)

for i=1:length(mainFolder) %iterate through the whole folder
    if (strcmp(num2str(mainFolder(i).name), '.')~=1 ) % and then, only if it's a real folder
        if (strcmp(num2str(mainFolder(i).name), '..')~=1 ) % and then, only if it's a real folder
            if (strcmp(num2str(mainFolder(i).name), completeFile)==1 )%if we found a .mat file
                %load the file
                S = load(strcat(path,'/',completeFile));
                
                % structure contains all fields of the stored struct
                % e.g. Coordinates, Name, Picture, isEmpty, etc.
                structure = getfield(S,'S');
                
                %extract inner data
                for x=1:length(S.S); % length(S) determines amount of pictures within the struct
                    if(isstr(c2) ==1 && findstr(c2, 'LBP')==1)
                        b = getfield(S.S(x), char(c1), char(c2));
                        data(x).values = b;
                    else
                        b = getfield(S.S(x), char(c1), char(c2(1)));
                        innerData(x,1) = b(1); %x1
                        if (length(b)==2)
                            innerData(x,2) = b(2); %x2
                        end
                    end
                end
                A = exist('innerData', 'var');
                if(A)
                    da = innerData;
                end
                
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



if(exist('data','var'))
    
else
    n = str2double(1);
    data(1).values = da;
end

%this was a nasty bug: da wasn't deleted afterwards, so for example
%after we dealt with 45 pictures and in the next run only 20,
%25 more were apended. FUCK.
da=[];
innerData=[];
end





