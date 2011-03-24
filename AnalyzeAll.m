function [  ] = AnalyzeAll( input )
%ANALYZEALL processes all folders containing images. This has to be
%set in here.
%     Folder:    ../Samples/
%
%
% Changelog:    
%               - [28.02.11] changed 'header  = cell(1,maxlen);' maxlen to '1' 
%               - [14.02.11] added amount, as an indicator for image number
%               - [14.02.11] added textures file which contains all values
%               -added counter for numer of files, because I forgot it once
%               (getFolderNumber)
%               -added Basisvektoren
%               -fixed error in indices
%               -removed fprint for nicer output

%% Process 'Samples'
textures = 'textures.mat';
fileex = false;
mainFolder = input; 
r = dir(mainFolder);
tdb    = strcat(mainFolder, textures);
cnt = 0;


%first find the texture database which contains all values and delete it
for findtexture=1:length(r)
    if (strcmp(num2str(r(findtexture).name),  textures ) == 1)
        delete(tdb);
        break;
    end
end

%create new texture database
maxlen  = length(r) - 2; % coordinates && textures.mat itself

values  = zeros(maxlen,1); %square size at most
class   = cell(maxlen ,1);
header  = cell(1,1); %header later on stores all texture value names, but only ones
name    = cell(maxlen ,1);

save (tdb, 'values', 'class','header', 'name');

%now run analysis for all images
for l=1:length(r)
    if (r(l).isdir)  % only do something if it is a folder
        if (strcmp(num2str(r(l).name), '.')~=1 ) % and then, only if it's a real folder
            if (strcmp(num2str(r(l).name), '..')~=1 ) % and then, only if it's a real folder                fprintf(r(l).name);
                folder = strcat(mainFolder, r(l).name, '/');
                file = strcat(r(l).name, '.jpg');
                cnt = cnt+1;
                cnt = Main(folder,file,tdb,cnt);
            end
        end
    end
end
fprintf('---------------------------------------------------------------------------------\n ');
fprintf('Analysis complete !\n ');


fprintf('All done!\n ');


end

