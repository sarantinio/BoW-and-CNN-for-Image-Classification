function [minidx,centroids,labels, validity] = DunnsIndex(data, limit)
% close all;
% A = rand(100,2);
% B = rand(100,2) + 2;
% C = rand(100,2) + 4;
% D = rand(100,2) + 6;
% 
% data = [A;B;C;D];
% figure;plot(data(:,1),data(:,2),'r+');

validity = zeros(1, limit);

kmresults = cell(limit,2);
for k = 600:50:limit
   fprintf('Working KMeans for k = %d of %d\n',k,limit);
   [kmresults{k,1},kmresults{k,2}] = kmeans(data,k);  
   validity(k) = getDunnsIndex(data,kmresults{k,1});
    %figure;
    %gscatter(data(:,1),data(:,2),labels);
    %title(sprintf('Validity: %2.6f',validity(k)));
end

validity = validity(2:numel(validity));

[~,minidx] = min(validity);

minidx = minidx + 1;
centroids = kmresults{minidx,2};
labels = kmresults{minidx,1};
end

function validity = getDunnsIndex(data,labels)

%intra variance
intra = 0;
for i = 1:max(labels)
    datapoints = data(labels == i,:);
    centroid = mean(datapoints);
    
    for j = 1:size(datapoints,1)
        intra = intra + norm(datapoints(j,:) - centroid); %norm computes magnitude of this distance which is the euclidian distance
    end
end

intra = intra ./ size(data,1);

%inter variance
interlist = [];
for i = 1:max(labels)-1
    datapoints = data(labels == i,:);
    centroid_i = mean(datapoints);
    
    for j = i+1:max(labels)
        datapoints = data(labels == j,:);
        centroid_j = mean(datapoints);
        interlist(end + 1) = norm(centroid_i - centroid_j);       
    end
end
inter = min(interlist);

validity = intra/inter;
end
