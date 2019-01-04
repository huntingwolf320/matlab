function [ y ] = compound( a,b,n,f )
%a积分下界，b积分上界，n采样点数目，f积分函数
%y复合求积结果
h = (b - a) / n;
x = linspace(a,b,n+1);
yt = zeros(1, n+1);
yt(1) = h * 1; %sin(x)/x在0处极限为1
for i = 2:n+1
    yt(i) = h * f(x(i));
end
yt(1) = yt(1) / 2;
yt(n+1) = yt(n+1) / 2;
y = sum(yt);
end

