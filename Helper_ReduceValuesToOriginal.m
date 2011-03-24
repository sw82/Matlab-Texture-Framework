function Helper_ReduceValuesToOriginal(tdb)
% Changelog:
%               - [10.03.11] modified

load(tdb);
[a,b] = size(values);
increment = 4; %4
output = 'textures_Original.mat';
 
cnt=0;
bla = 1;
for i=1:a
    cnt=cnt+1;
    v(cnt,:) = values(bla,:);
    c(cnt,:) = class(bla,:);
    n(cnt,:) = name(bla,:);
    
    bla = bla + increment;
    
    if(bla>a)
        break
    end
end

values = v;
class =  c;
 name = n;

save (output,'class', 'values', 'header', 'name');
