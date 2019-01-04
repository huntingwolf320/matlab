image = imread('redapple.jpg');
image = im2double(image);
newimage = zeros(size(image,1)*size(image,2),3);

for i = 1:size(image,1)
    for j = 1:size(image,2)
        newimage((i-1)*size(image,2) + j,:) = reshape(image(i,j,:),1,3);
    end
end

index = zeros(size(image(:,:,1)),'uint8');

tmap1 = zeros(256, 3);
tmap2 = ones(256, 3);
map = cat(3,tmap1,tmap2);

[map] = divider(newimage,map,uint8(0),0);

newmap = zeros(256,3);
for i = 1:size(map,1)
    for j = 1:size(map,2)
        newmap(i,j) = mean(map(i,j,:));
    end
end

for i = 1:size(image,1)
    for j = 1:size(image,2)
        now = reshape(image(i,j,:),1,3);
        dist = zeros(1,256);
        dist = now.^2*ones(size(newmap'))+ones(size(now))*(newmap').^2-2*now*newmap';
        [value,key] = min(dist);
        index(i,j) = key - 1;
    end
end

imwrite(index,newmap,'apple_8bit.gif');
