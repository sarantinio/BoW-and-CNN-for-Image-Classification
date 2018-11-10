function bag = get_histo(vocabulary, testing_features_cell) 
bag = [];
for i = 1:numel(testing_features_cell)
    desc = testing_features_cell{i};
    bag_temp = zeros(1,size(vocabulary,2));
    for j = 1:size(desc,2)
        dist = [];
        for k = 1:size(vocabulary,2)
            dist(k) = norm(double(desc(:,j))-vocabulary(:,k));
        end
        [~,bin] =  min(dist);
        bag_temp(bin) = bag_temp(bin)+1;
    end
    bag = [bag; bag_temp];
%     figure;
%     bar(bag);
%     title(strcat(testing_images(i).folder,'/',testing_images(i).name));
end
end