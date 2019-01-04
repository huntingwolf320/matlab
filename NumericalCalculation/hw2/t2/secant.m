function [ flag,steps,eArr,tArr ] = secant( x1,x2,f,err )
% 输入：flag是否求解成功，x初始近似值，f函数，fn导数，err精度要求
% 输出：steps迭代步数，xnext输出结果值
    steps = 0;
    flag = 1;
    tArr(1) = 0;
    eArr(1) = 1;
    while 1 
        tic;
        if x1 == x2  
            flag = 0;
            break;  
        end
        xnext = x1 - (f(x1) * (x1 - x2))/(f(x1) - f(x2));  
        if abs(x1 - xnext) < err  
            break;  
        end
        x2 = x1; 
        x1 = xnext; 
        steps = steps + 1;
        tArr(steps+1) = toc + tArr(steps); 
        eArr(steps+1) = abs(x1 - xnext);
    end
end


