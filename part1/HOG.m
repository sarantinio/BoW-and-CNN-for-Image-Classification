function descriptor = HOG(im,sigma)

g = fspecial('gaussian',[sigma*6+1,sigma*6+1],sigma);
Gy = diff(g);
Gx = Gy';

c1 = conv2(im,Gx,'same');
c2 = conv2(im,Gy,'same');

mag = sqrt(c1.^2+c2.^2);
angle = atan(c2./c1) + pi/2;
descriptor = [];
y = @(x) getHistogram(x);
for row = 1:8:size(im,1)-15
    for col = 1:8:size(im,2)-15
        block(:,:,1) = angle(row:row+15,col:col+15);
        block(:,:,2) = mag(row:row+15,col:col+15);
        h = blockproc(block,[8 8],y)';
        h = h(:);
        h = h./norm(h(:));
        descriptor = [descriptor; h];
    end
end

function h = getHistogram(block)
binrange = 0:20*pi/180:pi;
mag = block.data(:,:,2);
angle = block.data(:,:,1);
h = zeros(1,numel(binrange)-1);
for i = 1:numel(binrange)-1
    idx = angle >= binrange(i) & angle < binrange(i+1);
    h(i) = sum(mag(idx));
end