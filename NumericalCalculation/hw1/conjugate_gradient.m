function [ x,err ] = conjugate_gradient( A,b,x0,steps )
%共轭梯度法
%x0初始向量， steps迭代步数，err相对误差的数组
%16340108 黎浩良 2018/05/14
    [col,row] = size(A);
    n = length(b);
    nx0 = length(x0);
    if row ~= col || n ~= row || nx0 ~= n
        disp("请输入正确的n*n方阵A,n维向量b,n维初始变量x0")
        return
    end
    x = x0;
    err = zeros(1,steps);
    
    %根据公式求分量
    r = b - A * x0;
    p = r;
    smaller = min([n steps]);
    for i = 1:smaller
        a = (dot(r,r))/(p' * A * p);
        x = x + a * p;
        rnext = b - A * x;
        p = rnext + ((dot(rnext,rnext))/(dot(r,r))) * p;
        r = rnext;
        err(i) = norm(A\b - x, 2)/norm(A\b, 2);
    end
end

