function bagOfWords()
%% Load Libraries
run('/home/juan/Documents/vlfeat-0.9.21/toolbox/vl_setup')
vl_setup demo

%% Calculate features or load from file
if ~(exist('airplanes_sift.mat', 'file') == 2)
    [images_airplanes, descriptors_airplanes] = load_images_get_sift('../Caltech4/ImageData/airplanes');
    save('airplanes_oppsift', 'descriptors_airplanes');
    save('airplanes_images', 'images_airplanes');
else
    descriptors_airplanes = load('airplanes_sift');
    descriptors_airplanes = descriptors_airplanes.descriptors_airplanes;
    images_airplanes = load('airplanes_images');
    images_airplanes = images_airplanes.images_airplanes;
end

if ~(exist('cars_sift.mat', 'file') == 2)
    [images_cars, descriptors_cars] = load_images_get_sift('../Caltech4/ImageData/cars');
    save('cars_sift', 'descriptors_cars');
    save('cars_images', 'images_cars');
else
    descriptors_cars = load('cars_sift');
    descriptors_cars = descriptors_cars.descriptors_cars;
    images_cars = load('cars_images');
    images_cars = images_cars.images_cars;
end
if ~(exist('faces_sift.mat', 'file') == 2)
    [images_faces, descriptors_faces] = load_images_get_sift('../Caltech4/ImageData/faces');
    save('faces_sift', 'descriptors_faces');
    save('faces_images', 'images_faces');
else
    descriptors_faces = load('faces_sift');
    descriptors_faces = descriptors_faces.descriptors_faces;
    images_faces = load('faces_images');
    images_faces = images_faces.images_faces;
end
if ~(exist('motorbikes_sift.mat', 'file') == 2)
    [images_motorbikes, descriptors_motorbikes] = load_images_get_sift('../Caltech4/ImageData/motorbikes');
    save('motorbikes_sift', 'descriptors_motorbikes');
    save('motorbikes_images', 'images_motorbikes');
else
    descriptors_motorbikes = load('motorbikes_sift');
    descriptors_motorbikes = descriptors_motorbikes.descriptors_motorbikes;
    images_motorbikes = load('motorbikes_images');
    images_motorbikes = images_motorbikes.images_motorbikes;
end

%% vocab feaetures 1 -> 50 images
vocab_images = [images_airplanes(1:50), images_cars(1:50), images_faces(1:50), images_motorbikes(1:50)];
vocab_features_cell = [descriptors_airplanes(:,1:50), descriptors_cars(:,1:50), descriptors_faces(:,1:50), descriptors_motorbikes(:,1:50)];
vocab_features = cell2arr(vocab_features_cell);


%% Create vocabulary
if ~(exist('vocabulary.mat', 'file') == 2)
    %[minidx,vocabulary,~] = DunnsIndex(double(vocab_features'), 1000);
    %[vocabulary, assignments] = vl_kmeans(double(vocab_features), 400) ;
    [~,vocabulary] = kmeans(double(vocab_features'),800);
    save('vocabulary', 'vocabulary');
else
    vocabulary = load('vocabulary');
    vocabulary = vocabulary.vocabulary;
end
vocabulary=vocabulary';

%% prepare SVMs data 250 -> size of train set
% airplanes
if ~(exist('airplane_neg.mat', 'file') == 2)
    airplane_features_pos = descriptors_airplanes(:,251:end-50);
    airplane_features_neg = [descriptors_cars(:,251:end-50), descriptors_faces(:,251:end-50), descriptors_motorbikes(:,251:end-50)];
    airplane_pos = get_histo(vocabulary, airplane_features_pos);
    airplane_neg = get_histo(vocabulary, airplane_features_neg); 
    save('airplane_pos', 'airplane_pos');
    save('airplane_neg', 'airplane_neg');
else 
    airplane_pos = load('airplane_pos');
    airplane_pos = airplane_pos.airplane_pos;
    airplane_neg = load('airplane_neg');
    airplane_neg = airplane_neg.airplane_neg;
end

% cars
if ~(exist('cars_neg.mat', 'file') == 2)
    cars_features_pos = descriptors_cars(:,251:end-50);
    cars_features_neg = [descriptors_airplanes(:,251:end-50), descriptors_faces(:,251:end-50), descriptors_motorbikes(:,251:end-50)];
    cars_pos = get_histo(vocabulary, cars_features_pos);
    cars_neg = get_histo(vocabulary, cars_features_neg); 
    save('cars_pos', 'cars_pos');
    save('cars_neg', 'cars_neg');
else 
    cars_pos = load('cars_pos');
    cars_pos = cars_pos.cars_pos;
    cars_neg = load('cars_neg');
    cars_neg = cars_neg.cars_neg;
end


% faces
if ~(exist('faces_neg.mat', 'file') == 2)
    faces_features_pos = descriptors_faces(:,251:end-50);
    faces_features_neg = [descriptors_cars(:,251:end-50), descriptors_airplanes(:,251:end-50), descriptors_motorbikes(:,251:end-50)];
    faces_pos = get_histo(vocabulary, faces_features_pos);
    faces_neg = get_histo(vocabulary, faces_features_neg); 
    save('faces_pos', 'faces_pos');
    save('faces_neg', 'faces_neg');
else 
    faces_pos = load('faces_pos');
    faces_pos = faces_pos.faces_pos;
    faces_neg = load('faces_neg');
    faces_neg = faces_neg.faces_neg;
end


% motorbikes
if ~(exist('motorbikes_neg.mat', 'file') == 2)
    motorbikes_features_pos = descriptors_motorbikes(:,251:end-50);
    motorbikes_features_neg = [descriptors_cars(:,251:end-50), descriptors_faces(:,251:end-50), descriptors_airplanes(:,251:end-50)];
    motorbikes_pos = get_histo(vocabulary, motorbikes_features_pos);
    motorbikes_neg = get_histo(vocabulary, motorbikes_features_neg); 
    save('motorbikes_pos', 'motorbikes_pos');
    save('motorbikes_neg', 'motorbikes_neg');
else 
    motorbikes_pos = load('motorbikes_pos');
    motorbikes_pos = motorbikes_pos.motorbikes_pos;
    motorbikes_neg = load('motorbikes_neg');
    motorbikes_neg = motorbikes_neg.motorbikes_neg;
end

%% Load Test images
testing_images_airplane = images_airplanes(:,end-50+1:end);
testing_features_airplane = get_histo(vocabulary,descriptors_airplanes(:,end-50+1:end));

testing_images_cars = images_cars(:,end-50+1:end);
testing_features_cars = get_histo(vocabulary,descriptors_cars(:,end-50+1:end));

testing_images_faces = images_faces(:,end-50+1:end);
testing_features_faces = get_histo(vocabulary,descriptors_faces(:,end-50+1:end));

testing_images_motorbikes = images_motorbikes(:,end-50+1:end);
testing_features_motorbikes = get_histo(vocabulary,descriptors_motorbikes(:,end-50+1:end));

%% SVM airplanes
all_images = [testing_images_airplane, testing_images_cars, testing_images_faces, testing_images_motorbikes];
labels_airplane = zeros(1,size(airplane_pos,1) + size(airplane_neg,1));
labels_airplane(1:size(airplane_pos,1)) = 1;

model_airplanes = train(labels_airplane', sparse([airplane_pos;airplane_neg]), '-c 1');

labels_airplane_test = zeros(1,size(testing_features_airplane,1) + size(testing_features_cars,1) + size(testing_features_faces,1) + size(testing_features_motorbikes,1))';
labels_airplane_test(1:size(testing_features_airplane,1)) = 1;

[predict_label_airplane, accuracy_airplane, dec_values_airplane] = predict(labels_airplane_test, sparse([testing_features_airplane; testing_features_cars; testing_features_faces; testing_features_motorbikes]), model_airplanes);
[~, order] = sort(dec_values_airplane, 'descend');
ordered_images_airplane = all_images(order);
ap_airplane = get_AP(predict_label_airplane, labels_airplane_test);

% Mdl = TreeBagger(50,[airplane_pos;airplane_neg],labels_airplane','OOBPrediction','On','Method','classification');
% [Yfit,scores,stdevs] = predict(Mdl,testing_features_airplane);
%% SVM Cars
all_images = [testing_images_cars, testing_images_airplane, testing_images_faces, testing_images_motorbikes];

labels_cars = zeros(1,size(cars_pos,1) + size(cars_neg,1));
labels_cars(1:size(cars_pos,1)) = 1;

model_cars = train(labels_cars', sparse([cars_pos;cars_neg]), '-c 1');

labels_cars_test = zeros(1,size(testing_features_cars,1) + size(testing_features_airplane,1) + size(testing_features_faces,1) + size(testing_features_motorbikes,1))';
labels_cars_test(1:size(testing_features_cars,1)) = 1;


[predict_label_cars, accuracy_cars, dec_values_cars] = predict(labels_cars_test, sparse([testing_features_cars; testing_features_airplane; testing_features_faces; testing_features_motorbikes]), model_cars);
[~, order] = sort(dec_values_cars, 'descend');
ordered_images_cars = all_images(order);
ap_cars = get_AP(predict_label_cars, labels_cars_test);

%% SVM Faces
all_images = [testing_images_faces, testing_images_airplane, testing_images_cars, testing_images_motorbikes];

labels_faces = zeros(1,size(faces_pos,1) + size(faces_neg,1));
labels_faces(1:size(faces_pos,1)) = 1;

model_faces = train(labels_faces', sparse([faces_pos;faces_neg]), '-c 1');

labels_faces_test = zeros(1,size(testing_features_faces,1) + size(testing_features_airplane,1) + size(testing_features_cars,1) + size(testing_features_motorbikes,1))';
labels_faces_test(1:size(testing_features_faces,1)) = 1;

[predict_label_faces, accuracy_faces, dec_values_faces] = predict(labels_faces_test, sparse([testing_features_faces; testing_features_airplane; testing_features_cars; testing_features_motorbikes]), model_faces);
[~, order] = sort(dec_values_faces, 'descend');
ordered_images_faces = all_images(order);
ap_faces = get_AP(predict_label_faces, labels_faces_test);

%% SVM Motorbikes
all_images = [testing_images_motorbikes, testing_images_airplane, testing_images_cars, testing_images_faces];

labels_motorbikes = zeros(1,size(motorbikes_pos,1) + size(motorbikes_neg,1));
labels_motorbikes(1:size(motorbikes_pos,1)) = 1;

model_motorbikes = train(labels_motorbikes', sparse([motorbikes_pos;motorbikes_neg]), '-c 1');

labels_motorbikes_test = zeros(1,size(testing_features_motorbikes,1) + size(testing_features_airplane,1) + size(testing_features_cars,1) + size(testing_features_faces,1))';
labels_motorbikes_test(1:size(testing_features_motorbikes,1)) = 1;

[predict_label_motorbikes, accuracy_motorbikes, dec_values_motorbikes] = predict(labels_motorbikes_test, sparse([testing_features_motorbikes; testing_features_airplane; testing_features_cars; testing_features_faces]), model_motorbikes);
[~, order] = sort(dec_values_motorbikes, 'descend');
ordered_images_motorbikes = all_images(order);
ap_motorbikes = get_AP(predict_label_motorbikes, labels_motorbikes_test);

outputHtml(ordered_images_airplane, ordered_images_cars, ordered_images_faces, ordered_images_motorbikes, ap_airplane, ap_cars, ap_faces, ap_motorbikes);

end

