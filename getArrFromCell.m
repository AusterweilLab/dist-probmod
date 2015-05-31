function [ arr] = getArrFromCell(cellArr,is,js)
%GETARRFROMCELL 

arr = zeros(length(is),length(js));

for i = 1:length(is)
    for j = 1:length(js)
        arr(i,j) = cellArr{is(i),js(j)};
    end
end


end

