%计算GIF压缩时的失真度
img1 = imread('动物卡通图片.jpg');
img2 = imread('动物照片.jpg');

img1gif = imread('gifCartoon.gif');
img2gif = imread('gifPhoto.gif');

img1gifDis = sum(sum(sum((img1-img1gif).^2)))/(prod(size(img1)))
img2gifDis = sum(sum(sum((img2-img2gif).^2)))/(prod(size(img2)))