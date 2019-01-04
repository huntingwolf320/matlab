function [ x,err ] = loose_iteration( A,b,x0,steps,w )
%逐次超松弛迭代法
%x0初始向量， steps迭代步数，err相对误差的数组，w松弛因子
%16340108 黎浩良 2018/05/14
    [col,row] = size(A);
    n = length(b);
    nx0 = length(x0);
    if row ~= col || n ~= row || nx0 ~= n
        disp("请输入正确的n*n方阵A,n维向量b,n维初始变量x0")
        return
    end
    x = zeros(n,1);
    err = zeros(1,steps);
    
    %根据公式求分量
    i = 1;
    while i <= steps
        for j = 1:n
            x(j) = x0(j) + w * (b(j) - A(j, j:n) * x0(j :n) - A(j, 1:j-1) * x(1:j-1)) / A(j, j);
        end
        x0 = x;
        %计算相对误差，误差向量的与真值向量的二范数之比
        err(i) = norm(A\b - x, 2)/norm(A\b, 2);
        i = i + 1;
    end
end

