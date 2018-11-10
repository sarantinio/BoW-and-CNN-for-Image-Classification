function all_desc = run_hog_set(all_image_dirs) 
    all_desc = {};
    for i = 1:numel(all_image_dirs)
        im = imread(strcat(all_image_dirs(i).folder, '/', all_image_dirs(i).name));

        if ndims(im) == 3
            im = single(rgb2gray(im));
        else
            im = single(im);
        end

        desc = runHog(im);
        all_desc{end+1} = desc;
    end
end