function rgb = im2rgb(image)
    if ndims(image) == 3
        R = image(:,:,1);
        G = image(:,:,2);
        B = image(:,:,3);

        rgb(:,:,1) = R ./ (R+G+B);
        rgb(:,:,2) = G ./ (R+G+B);
        rgb(:,:,3) = B ./ (R+G+B);
    else 
       rgb = image; 
    end
end