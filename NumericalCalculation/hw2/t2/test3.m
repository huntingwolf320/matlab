[flag,steps,eArr,tArr] = simplified_newton(10, @(x)x^2-115, @(x)2*x, 1e-6);
steps
vpa(x,8)
subplot(2,1,1);
%精度随步数的变化
plot(0:steps, eArr);
subplot(2,1,2);
%进度随时间的变化
plot(tArr, eArr);