function [f,d] = runSift(image,type, colorImage)
if strcmp(type, 'SIFT')
    [f,d] = vl_sift(image);
    if nargin == 3
        [~, d1] = vl_sift(im2single(colorImage(:,:,1)), 'frames', f);
        [~, d2] = vl_sift(im2single(colorImage(:,:,2)), 'frames', f);
        [~, d3] = vl_sift(im2single(colorImage(:,:,3)), 'frames', f);
        %% Normalising
        d1 = normc(single(d1));
        d1(d1 > 0.2) = 0.2;
        d1 = normc(d1);
        d2 = normc(single(d2));
        d2(d2 > 0.2) = 0.2;
        d2 = normc(d2);
        d3 = normc(single(d3));
        d3(d3 > 0.2) = 0.2;
        d3 = normc(d3);

        d = [d1,d2,d3];
    end
    d = normc(single(d));
    d(d > 0.2) = 0.2;
    d = normc(d);

elseif strcmp(type,'DSIFT')
    [f,d] = vl_dsift(image,'step',10);
    d = normc(single(d));
    d(d > 0.2) = 0.2;
    d = normc(d);
end
end