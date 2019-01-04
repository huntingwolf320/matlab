function [map] = divider( img,map,flag,time )
%img图像RGB矩阵，map颜色查找表，flag划分区域标记，time划分次数
    color = mod(time,3) + 1;
    med = median(img(:,color));
    
    highimg = zeros(fix(size(img,1)/2),3);
    lowimg = zeros(size(img,1)-fix(size(img,1)/2),3);
    
    counthigh = 0;
    countlow = 0;
    for i = 1:size(img,1)
        if img(i,color) > med
            counthigh = counthigh + 1;
            highimg(counthigh,:) = img(i,:); 
        end
        if img(i,color) < med
            countlow = countlow + 1;
            lowimg(countlow,:) = img(i,:); 
        end
    end
    for i = 1:size(img,1)
        if img(i,color) == med
            if counthigh < size(highimg,1)
                counthigh = counthigh + 1;
                highimg(counthigh,:) = img(i,:);                
            else
                countlow = countlow + 1;
                lowimg(countlow,:) = img(i,:); 
            end     
        end
    end
    for i = 0:2^(7-time)-1
        map(i * 2^(time+1) + double(flag) + 1,color,2) = med;
        map(i * 2^(time+1) + double(bitset(flag,time+1)) + 1,color,1) = med;        
    end
    if time < 7
        [map] = divider(lowimg,map,flag,time+1);
        [map] = divider(highimg,map,bitset(flag,time+1),time+1);
    end
end


