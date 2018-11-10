function all_desc = run_sift_set(all_image_dirs, descType, siftType) 
    all_desc = {};
    for i = 1:numel(all_image_dirs)
        im = imread(strcat(all_image_dirs(i).folder, '/', all_image_dirs(i).name));

        if ~(siftType == "")
            if siftType == 'RGB'
                im2 = im; 
            elseif siftType == 'rgb'
                im2 = im2rgb(im);
            elseif siftType == 'opp'
                im2 = im2rgb(im);
                im2 = rgb2opp(im2);
            end
            if ndims(im) == 3
                im = single(rgb2gray(im));
                [~,desc] = runSift(im, descType, im2);
                all_desc{end+1} = desc;
            else 
               im = single(im); 
               [~,desc] = runSift(im, descType);
                all_desc{end+1} = desc;
            end
        else
            if ndims(im) == 3
                im = single(rgb2gray(im));
            else
                im = single(im);
            end
            [~,desc] = runSift(im, descType);
            all_desc{end+1} = desc;
        end
    end
end