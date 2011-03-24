function [ output_args ] = Helper_GetSpecificValue( tdb, value, output )
%Helper_GetSpecificValue get a specific .mat database, a searchvalue and
%and output, to extract certain values out of the complete database
%   Helper_GetSpecificValue('textures_alle.mat', 'Zoom',
%   'textures_Zoom.mat')

% Changelog:    - [07.03.11]    creation
%                               added name and class reduction from another
%                               file

load(tdb)
[a,b] = size(values);
%a equals number of rows, so in this case different picures
%b equals number of different features.




cnt=1;
bla = 1;
for i=1:a    
    currentmatch = findstr(char(name(i)), value);
    if(~isempty(currentmatch))
        v(cnt,:) = values(i,:);
        c(cnt,:) = name(i,:);
        cl(cnt,:)= class(i,:);
        cnt = cnt +1;
    end    
end

values = v;
name =  c;
classes = cl;

%Reduce classes and name(s) because it is there four times and it's only
%needed once
cnt=0;
n = name;
c = classes;
eString = cellstr('');
bla = 1;
for i=1:a
    cnt=cnt+1;
    bb=bla+3;
    for aa=bla+1:bb
       n(aa)= eString; 
       c(aa)= eString;
    end
    
    bla = bla + 4;
    
    if(bla>a)
        break
    end
end

name = n(1:length(name));

classes = c(1:length(name));


save (output, 'classes', 'values', 'header', 'name');
end

