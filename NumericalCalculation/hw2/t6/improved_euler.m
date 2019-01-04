function [ ] = improved_euler( )
%改进欧拉法
    a = 0;
    b = 1;
    h = 0.1;
    y0 = 1;
    f = @(x,y)y-(2*x)/y;

    x = a:h:b;
    y = zeros(1, length(x)-1);
    y(1) = y0;
    for i = 1:length(x)-1
        k1 = feval(f,x(i),y(i));
        y(i+1) = y(i) + h*k1;
        k2 = feval(f,x(i+1),y(i+1));
        y(i+1) = y(i) + h*(k1+k2)/2;
    end
    plot(x,y);
end

