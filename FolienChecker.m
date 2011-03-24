function [ folie ] = FolienChecker(folie, X, values)

difference = 0.1; %max. value both can differ and are still the same

for z=1:length(values)
    currentColumn = X.(char(values(z)));
    for currentIterator=1:2:length(currentColumn)
       without = currentColumn(currentIterator); %wert ohne folie
       with = currentColumn(currentIterator+1); %wert mit folie
       if(with<=without)
           small = with;
           big = without;
       else
           small = without;
           big = with;
       end
       
       small = small + small * difference;
       
       if(small>=big)%values are almost the same
           folie(currentIterator, z) = folie(currentIterator, z) + 1;
       end
       
        
    end
    
end

end