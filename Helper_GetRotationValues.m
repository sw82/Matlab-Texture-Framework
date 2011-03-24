function [ output_args ] = Helper_GetRotationValues( tdb, output )
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

o1 = 'O180';
o2 = 'O270';
o3 = 'O90';
o4 = 'Original';


cnt=1;
bla = 1;
for i=1:a    
    cm1 = findstr(char(name(i)), o1);
    cm2 = findstr(char(name(i)), o2);
    cm3 = findstr(char(name(i)), o3);
    cm4 = findstr(char(name(i)), o4);
    
    if(~isempty(cm1)|| ~isempty(cm2) || ~isempty(cm3) || ~isempty(cm4))
        v(cnt,:) = values(i,:);
        c(cnt,:) = name(i,:);
        cl(cnt,:)= class(i,:);
        cnt = cnt +1;
    end    
end

values = v;
name =  c;
classes = cl;
v= [];
n={};
c={};


%Reduce to only Original
increment = 4; %4
[a,b] = size(values); 
cnt=0;
bla = 1;
for i=1:a
    cnt=cnt+1;
    v(cnt,:) = values(bla,:);
    n(cnt,:) = name(bla,:);
    c(cnt,:) = classes(bla,:);
    bla = bla + increment;
    
    if(bla>a)
        break
    end
end

values = v;
classes = c;
name =  n;
 



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

