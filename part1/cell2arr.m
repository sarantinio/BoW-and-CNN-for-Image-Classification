function arr = cell2arr(cell) 
    arr = [];
    for i = 1:size(cell,2)
        arr = [arr cell{i}];
    end
end