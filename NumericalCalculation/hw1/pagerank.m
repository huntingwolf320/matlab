function [ pr,err ] = pagerank( count,data,d,steps )
%pagerank算法
%steps迭代步数 d阻尼系数
%16340108 黎浩良 2018/05/14
    vote = zeros(count,1);%每个网站的外链数
    for i = 1:size(data,1)
        vote(data(i)+1) = vote(data(i)+1) + 1;
    end
    
    pr = zeros(count,1);
    p0 = ones(count,1);%初始信任分值
    err = zeros(1,steps);

    for s = 1:steps
        for i = 1:count
            pr(i) = (1-d)/count;            
        end
        for i = 1:size(data,1)
            pr(data(i,2)+1) = pr(data(i,2)+1) + d * p0(data(i)+1) / vote(data(i)+1);            
        end
        err(s) = norm(p0-pr);  
        p0=pr; 
    end  
end

