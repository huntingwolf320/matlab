function [ ] = back_euler( )
% 后向欧拉法
    a = 0;
    b = 1;
    h = 0.1;
    y0 = 1;
    f = @(x,y)y-(2*x)/y;

    x = a:h:b;
    y = zeros(1, length(x)-1);
    y(1) = y0;
    for i = 1:length(x)-1
        y(i+1) = iteration(f,x(i+1),y(i),h);
    end
    plot(x,y);
end
function y = iteration(f,x,y,h)
    yn = y;
    e = 1e-4;
    y = y + h * feval(f, x, y);
    err = +inf;
    while 1
        yl = y;
        y = yn + h * feval(f,x,y);
        if abs(yl-y) > err
            error('迭代发散');
        end
        err = abs(yl-y);
        if err < e
            break;
        end
    end
end