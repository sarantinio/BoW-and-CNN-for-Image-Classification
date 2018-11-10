function [images, descriptors] = load_images_get_sift(path, descType, colorType)

if nargin == 1
   descType = 'SIFT';
   colorType= '';
end

test_set = dir(strcat(path,'_test/*.jpg'));
train_set = dir(strcat(path,'_train/*.jpg'));

train_descriptors = run_sift_set(train_set, descType, colorType);
test_descriptors = run_sift_set(test_set, descType, colorType);

descriptors = [train_descriptors, test_descriptors];
images = [train_set', test_set'];
end
