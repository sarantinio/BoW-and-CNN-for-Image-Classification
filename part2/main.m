 %main function 
 

   

%% fine-tune cnn

[net, info, expdir] = finetune_cnn();

save(fullfile(expdir, 'fine_tuned.mat'), 'net');


%% extract features and train svm
 

% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, 'fine_tuned.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%

addpath(genpath('liblinear-2.1'));

train_svm(nets, data);
 

%% VISUALIZATION 

addpath(genpath('tSNE_matlab'));

 figure;
 [pre_feat,pre_lab]=tsne_visualize(nets.pre_trained,data,"Pre trained");
 figure;
 [fine_feat,fine_lab]=tsne_visualize(nets.fine_tuned,data,"Fine tuned") ;

 
 

function [img_feat,img_lab] = tsne_visualize(network, data, type)
    img_labels = [];
    img_features = [];  
    network.layers{end}.type = 'softmax';
    img_count = size(data.images.data,4);
    
    for i = 1:img_count
        net_model = vl_simplenn(network, data.images.data(:, :,:, i));
        squeeze_net_model = squeeze(net_model(end-3).x);
        if ne(data.images.set(i) , 1)%train set
            img_features = [img_features squeeze_net_model];
            img_labels   = [img_labels;  data.images.labels(i)];
        end
    end
    
    img_feat = double(img_features');
    img_lab = double(img_labels);
    
    
    tsne_res = tsne(img_feat, img_lab,64);
    gscatter(tsne_res(:,1),tsne_res(:,2), img_labels);
    title(type);
    

   
end
