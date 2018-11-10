function out = rgb2opp(image)
if ndims(image) == 3
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);

    out(:,:,1) = double((R-G)) ./ double(sqrt(2));
    out(:,:,2) = double(R+G-2*B) ./ double(sqrt(6));
    out(:,:,3) = double(R+G+B) ./ double(sqrt(3));
else 
   out = image; 
end


end