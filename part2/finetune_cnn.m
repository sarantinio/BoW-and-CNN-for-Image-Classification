function [net, info, expdir] = finetune_cnn(varargin)




%% Define options
run(fullfile(fileparts(mfilename('fullpath')),'matconvnet','matlab', 'vl_setupnn.m')) ;


opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

% turning off gpu support 
opts.train.gpus = [];



%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end







% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%count the total number of images
total_images = numel(dir(strcat('../Caltech4/ImageData/','*_*','/*.jpg')));

sets = single(zeros(1,total_images));
labels = single(zeros(1,total_images));
data = single(zeros(32,32,3,total_images));


total_count = 1;
for which = 1:length(splits)
    for i = 1:length(classes)
        im_dir = dir(strcat('../Caltech4/ImageData/', classes{i},'_', splits{which}, '/*.jpg'));
        num_imgs = numel(im_dir);
        for j = 1:num_imgs
            
            %read and resize image
            im_name = strcat(im_dir(1).folder, '/', im_dir(j).name);
            image = im2single(imread(im_name));
            if size(image,3) ~= 3
                %if gray image
                image = repmat(image,1,1,3);
            end
            image = imresize(image, [32 32]);
            %----------------------
            
            data(:,:,:,total_count) = image;
            
            if strcmp(splits(which),splits(1)) % 1 or 2 for train or test 
                sets(total_count) = 1;
            else
                sets(total_count) = 2;
            end

            
            if strcmp(classes(i),classes(1)) % 1 to 4 for each class
                labels(total_count) = 1;
            elseif strcmp(classes(i),classes(2))
                labels(total_count) = 2;
            elseif strcmp(classes(i),classes(3))
                labels(total_count) = 3;
            elseif strcmp(classes(i),classes(4))
                labels(total_count) = 4;
            end
            total_count = total_count + 1;
            
        end
    end
end

data = single(data);
labels = single(labels);
sets = single(sets);




%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
