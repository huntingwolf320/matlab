image1 = imread('Åµ±´¶û.jpg');
image2 = imread('lena.jpg');

[x,y,z] = size(image1);

centerX = x/2;
centerY = y/2;

for t = 0:0.01:1
    image = image1;
    for i = 1:x
        for j = 1:y
            if (i-centerX)^2 + (j-centerY)^2 < (centerX^2 + centerY^2) * t
                image(i,j,:) = image2(i,j,:);
            end
        end
    end
    [I,map] = rgb2ind(image,256);
    if(t == 0)        
        imwrite(I,map,'movefig.gif','DelayTime',0.1,'LoopCount',Inf);    
    else
        imwrite(I,map,'movefig.gif','WriteMode','append','DelayTime',0.1);    
    end  
end




