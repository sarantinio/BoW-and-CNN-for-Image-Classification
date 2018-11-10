function save_features() 
run('/home/juan/Documents/vlfeat-0.9.21/toolbox/vl_setup')
vl_setup demo

if ~(exist('airplanes_RGBsift.mat', 'file') == 2)
    [images_airplanes, descriptors_airplanes] = load_images_get_sift('../Caltech4/ImageData/airplanes', "SIFT","RGB");
    save('airplanes_RGBsift', 'descriptors_airplanes');
else
    descriptors_airplanes = load('airplanes_dsift');
    descriptors_airplanes = descriptors_airplanes.descriptors_airplanes;
    images_airplanes = load('airplanes_images');
    images_airplanes = images_airplanes.images_airplanes;
end

if ~(exist('cars_RGBsift.mat', 'file') == 2)
    [images_cars, descriptors_cars] = load_images_get_sift('../Caltech4/ImageData/cars', "SIFT","RGB");
    save('cars_RGBsift', 'descriptors_cars');
    save('cars_images', 'images_cars');
else
    descriptors_cars = load('cars_sift');
    descriptors_cars = descriptors_cars.descriptors_cars;
    images_cars = load('cars_images');
    images_cars = images_cars.images_cars;
end
if ~(exist('faces_RGBsift.mat', 'file') == 2)
    [images_faces, descriptors_faces] = load_images_get_sift('../Caltech4/ImageData/faces', "SIFT","RGB");
    save('faces_RGBsift', 'descriptors_faces');
    save('faces_images', 'images_faces');
else
    descriptors_faces = load('faces_sift');
    descriptors_faces = descriptors_faces.descriptors_faces;
    images_faces = load('faces_images');
    images_faces = images_faces.images_faces;
end
if ~(exist('motorbikes_RGBsift.mat', 'file') == 2)
    [images_motorbikes, descriptors_motorbikes] = load_images_get_sift('../Caltech4/ImageData/motorbikes', "SIFT", "RGB");
    save('motorbikes_RGBsift', 'descriptors_motorbikes');
    save('motorbikes_images', 'images_motorbikes');
else
    descriptors_motorbikes = load('motorbikes_sift');
    descriptors_motorbikes = descriptors_motorbikes.descriptors_motorbikes;
    images_motorbikes = load('motorbikes_images');
    images_motorbikes = images_motorbikes.images_motorbikes;
end



end