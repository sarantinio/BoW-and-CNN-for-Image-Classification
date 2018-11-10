function [images, descriptors] = load_images_get_sift(path)
test_set = dir(strcat(path,'_test/*.jpg'));
train_set = dir(strcat(path,'_train/*.jpg'));

train_descriptors = run_hog_set(train_set);
test_descriptors = run_hog_set(test_set);

descriptors = [train_descriptors, test_descriptors];
images = [train_set', test_set'];
end
