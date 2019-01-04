function [ steps,x,eArr,tArr ] = dichotomy( a,b,f,err )
%输入：f为要求解的方程函数表达式，a为求解区间的下界，b为求解区间的上界，err为所要求的误差范围
%输出：steps为二分法求解的次数，x为最终的根，y为方程的根x对应的函数值
    if f(a)*f(b)>0
        disp('\n注意：无效的求根区间\n');
        return;
    end
    steps = 0;
    tArr(1) = 0;
    eArr(1) = b-a;
    while 1
        tic;
        x=(a + b) / 2;
        y=f(x);
        if y == 0
            a = x; 
            b = x;
        elseif f(a) * y < 0
            b = x;
        else
            a = x;
        end
        if abs(b - a) <= err
            break;
        end
        steps = steps + 1;
        tArr(steps+1) = toc + tArr(steps); 
        eArr(steps+1) = b-a;
    end
end