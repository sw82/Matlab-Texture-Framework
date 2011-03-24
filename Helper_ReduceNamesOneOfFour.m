function Helper_ReduceNamesOneOfFour(texturedatabase)
% Changelog:
%               - [07.03.11] added class 
%                           now obsolete - already in another function
%               - [28.02.11] changed to function to receive input param

load(texturedatabase)
[a,b] = size(values);
cnt=0;
n = name;
c = class;
kacka = cellstr('');
bla = 1;
for i=1:a
    cnt=cnt+1;
    bb=bla+3;
    for aa=bla+1:bb
       n(aa)= kacka; 
       c(aa)= kacka;
    end
    
    bla = bla + 4;
    
    if(bla>a)
        break
    end
end

save (texturedatabase, 'classes', 'values', 'header', 'name', 'n');
