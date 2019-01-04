function [ ] = rls(  )
%递推最小二乘法解超定线性方程组
    %生成超定线性方程组
    n = 10;
    m = 1000;
    DataA = normrnd(0,1,m,n);
    Datab = normrnd(0,1,m,1);
    
    A = DataA(1:n, :);
    b = Datab(1:n);
    Gn = inv(A'*A);
    x = (A' * A) \ (A' * b);
    steps = 0;
    err = zeros(1, steps);
    for i = n+3:m
        xnewRow = DataA(i,:);
        M = 1 + xnewRow*(Gn * xnewRow');
        xnext = x + ((Gn * xnewRow') / M) *(Datab(i) - xnewRow * x);
        Gn = Gn - ((Gn * xnewRow') / M) * (xnewRow * Gn);
        steps = steps + 1;
        err(steps) = norm(x - xnext, 2);
        x = xnext;
    end
    plot(1:steps,err);
end

