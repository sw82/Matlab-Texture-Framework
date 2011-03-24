function [  ] = GrafischeAuswertung()
% Creates a lot of graphics in a specified folder

% Changelog:    -


tic

%% PARAMETERS:
structextension = '.mat';
file            = 'S';%filename of the struct containing the values (e.g. S.mat)
feature_one    = 'Haralick'; %string to look for in file
feature_two   = 'Laws';
feature_three = 'LBP';
haralicks       = {'Haralick0'; 'Haralick45'; 'Haralick135';'Haralick90'};

%% Change the current folder to the folder of this m-file
if(~isdeployed)
    cd(fileparts(which(mfilename)));
end

%% Process 'Samples'
mainFolder = '../Samples/';
r = dir(mainFolder);

%% Receive the content of the features stored in S
fprintf('Receiving feature content...\n');
for l=1:length(r)
    if (r(l).isdir)
        if (r(l).name ~= '.')
            folder = strcat(mainFolder, r(l).name, '/');
            
            %for each S.mat
            
            % values = all sub values from a given searchstring within the file
            
            % Haralicks
            values_one = Cl_GetClusterContent(folder, file, structextension, feature_one);
            
            % Laws
            values_two = Cl_GetClusterContent(folder, file, structextension, feature_two);
            
            % LBP
            values_three = Cl_GetClusterContent(folder, file, structextension, feature_three);
            
            break;
        end
    end
end
%% content is now is stored in: values_one, values_two

%Laws
ProcessData(Cl_GetClusterContent(folder, file, structextension, feature_two), 'Laws');

%Haralick
ProcessData(Cl_GetClusterContent(folder, file, structextension, feature_one), 'Haralick');

%Rotation invariant Histogram
ProcessData(Cl_GetClusterContent(folder, file, structextension, feature_three), 'LBP26');

return; %from main


function ProcessData(values, textureFeature)
%iterate through all value pairs in all folders
mainFolder = '../Samples/';
r = dir(mainFolder);

structextension = '.mat';
file            = 'S';%filename of the struct containing the values (e.g. S.mat)


for i=1:length(values)
    current ='';
    s={};
    fprintf('\n--------------Processing  feature %s, %i/%i --------------\n' ,char(values(i)), i,length(values) );
    
    %and do this for each folder
    for l=1:length(r)
        if (r(l).isdir)
            if (r(l).name ~= '.')
                
                folder = strcat(mainFolder, r(l).name, '/'); %current folder e.g. [../Samples/Blatt_mit/]
                
                tmp = r(l).name; % folder name e.g. [Blatt_180]
                
                str = regexp(tmp,'\_','split');%split string, to get something like 'Blatt' '180'
                %if current is still empty; current keeps track of the
                %current picture
                %needed for comparism against the following picture and
                %whether to start a new image or not
                if (strcmp('',current) == 1)
                    current = str(1);%if it is the first, remember current will be reset after each iteration
                end
                
                %Get current data
                if(findstr(textureFeature, 'LBP')==1)
                    if(i>1) %for LBP don't go in there for more than once
                        break;
                    end
                    val = Cl_GetClusterData(folder, file,  'LBP' , textureFeature, structextension); % extract data
                    %%Gather all values from all sub pictures in s
                    if isempty(s) %if the struct is empty, put in the first values
                        s = struct(str{2}, {val(1).values});
                        %otherwise create new struct and concat both
                    else
                        c = struct(str{2}, {val(1).values}); % new struct
                        fn1 = fieldnames(s);%old fieldnames
                        c1 = struct2cell(s);%convert to cell array
                        fn2 = fieldnames(c);%new (additional) fieldnames
                        c2 = struct2cell(c);%also convert the other struct
                        
                        fn = [fn1;fn2]; %merge the fieldnames
                        cc = [c1;c2]; %and merge the cell arrays
                        %to finally put together everything in the new struct
                        s = cell2struct(cc, fn,1);
                        % so s will be in the end something like:
                        
                        %                         s =
                        %     AutoTone: [1x26 double]
                        %     Exposure: [1x26 double]
                    end
                    %% Check if the next image is still in the same category...
                    if (l+1) <= length(r) %but only if there is a next picture
                        next =  r(l+1).name;
                    end
                     str2 = regexp(next,'\_','split');
                    if (strcmp(str2(1),current) == 0) %start creating a figure if a new picture is waiting in line
                                                
                        CreateHistogram(str(1), textureFeature, s);
                                                
                        %% Finally clear everything for the next category of samples
                        
                        current = ''; %set current again to nothing, 'cause the next one is coming
                        s=struct(); %and the struct is empty again
                    end
                    
                    
                    
                else
                    val = Cl_GetClusterData(folder, file, textureFeature, values(i) , structextension); % extract data
                    
                    %%Gather all values from all sub pictures in s
                    if isempty(s) %if the struct is empty, put in the first values
                        s = struct(str{2}, {val.values});
                        %otherwise create new struct and concat both
                    else
                        c = struct(str{2}, {val.values}); % new struct
                        fn1 = fieldnames(s);%old fieldnames
                        c1 = struct2cell(s);%convert to cell array
                        fn2 = fieldnames(c);%new (additional) fieldnames
                        c2 = struct2cell(c);%also convert the other struct
                        
                        fn = [fn1;fn2]; %merge the fieldnames
                        cc = [c1;c2]; %and merge the cell arrays
                        %to finally put together everything in the new struct
                        s = cell2struct(cc, fn,1);
                        % so s will be in the end something like:
                        
                        % s:
                        %       mit: [4x2 double]
                        %      ohne: [4x2 double]
                        %     weich: [4x2 double]
                    end
                    
                    %% Check if the next image is still in the same category...
                    if (l+1) <= length(r) %but only if there is a next picture
                        next =  r(l+1).name;
                    end
                    
                    str2 = regexp(next,'\_','split');
                    if (strcmp(str2(1),current) == 0) %start creating a figure if a new picture is waiting in line
                        fprintf('Processed: %s \n' ,char(str(1))); % Show which picture is being processed
                        %...if not, reset everyting
                        CreateFigure(s,current,values(i), textureFeature);
                        
                        %% Finally clear everything for the next category of samples
                        
                        current = ''; %set current again to nothing, 'cause the next one is coming
                        s=struct(); %and the struct is empty again
                    end
                end
            end
        end
        
    end
end
return;


function CreateHistogram(s1, textureFeature, val)
% visualize the histogram
% figure, bar(1:binNum26, hst26, 'r'), title('26bins LBP hist');
colors = ['y' 'm' 'c' 'r' 'g' 'b' 'k' 'w']; %set up a range of colors

%create plot
scrsz = get(0,'ScreenSize');
h = figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);

%size
ll = length(fieldnames(val)); % e.g. ll = 8

%structure
fn = fieldnames(val);

%for each entry
for j=1:ll
    subplot(ceil(ll/2),2,j)            
    b = getfield(val, char(fn(j)));    
    bar(1:length(b), b, colors(j));
    tit = strcat(s1, '.', char(fn(j)));
    title(tit, 'fontsize',15,'fontweight','b');    
end
%Set style and title

fname = strcat('../Output/',s1,'_', textureFeature, '.jpg');
%save
saveas(h, char(fname), 'jpg');
close(h); %close the image

return

function CreateFigure(s,current,current_value, y)
colors = ['y' 'm' 'c' 'r' 'g' 'b' 'k' 'w']; %set up a range of colors

%% Create figure/ plot
%preprocessing
fieldnms = fieldnames(s);

xaxis = [1/4 1/2 2/3 1];%x axis containing the pictures (full, half, quarter size)

%create plot
scrsz = get(0,'ScreenSize');
h = figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);


for j=1:length(fieldnms)
    v = getfield(s, fieldnms{j});%mit, ohne, weich,..
    val = v(:,1); %first column, containing 4 values for 4 pictures
    linestyle = '--';%can be also '' to avoid lines
    col = strcat(linestyle,    colors(j), 's'); % s=squares
    plot(xaxis,flipud(val),... %flip the vector, so the full size image value is in at end
        char(col), 'MarkerSize' , 10,... % convert character array to string [char(col)]
        'MarkerFaceColor', char(colors(j)));
    
    hold on
end

%Adjust the xaxis
set(gca, 'XTick',[0.25 0.5 0.66 1])
set(gca, 'XTickLabel',{'25%','50%','66%','100%'})
set(gca,'Color',[0.9,0.9,0.9])

%Legend
hleg = legend(fieldnms, 'Location', 'NorthEast');
set(hleg,'FontAngle','italic')

%Set style and title
title(current, 'fontsize',20,'fontweight','b');

%Background


%TODO
yl = strcat(y ,'(', ' ' ,current_value, ')');
ylabel(yl, 'fontsize',12,'fontweight','b');
xlabel('Image size','fontsize',12,'fontweight','b');
grid on;
hold off

%%Save image
%create a filename: e.g. SAMPLE_FEATURE/SUBFEATURE.jpg
fname = strcat('../Output/',current,'_', yl, '.jpg');
%save
saveas(h, char(fname), 'jpg');
close(h); %close the image
return;

toc