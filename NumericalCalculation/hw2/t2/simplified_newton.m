function [ flag,steps,eArr,tArr ] = simplified_newton( x,f,fn,err )
% 输入：flag是否求解成功，x初始近似值，f函数，fn导数，err精度要求
% 输出：steps迭代步数，xnext输出结果值,
    steps = 0;
    flag = 1;
    c = 1/fn(x);
    tArr(1) = 0;
    eArr(1) = 1;
    while 1 
        tic;
        if fn(x) == 0  
            flag = 0;
            break;  
        end
        xnext = x - c*f(x);  
        if abs(x - xnext) < err  
            break;  
        end
        x = xnext; 
        steps = steps + 1;
        tArr(steps+1) = toc + tArr(steps); 
        eArr(steps+1) = abs(x - xnext);
    end
end


