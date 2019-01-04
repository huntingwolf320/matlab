function [ y ] = simpson( a,b,n,f )
%a积分下界，b积分上界，n采样点数目，f积分函数
%y复合求积结果
h = (b - a) / n;
x = linspace(a,b,2*n+1);
yt = zeros(1, n+1);
yt(1) = 1; %sin(x)/x在0处极限为1
for i = 2:2*n+1
    yt(i) = f(x(i));
end
yt(2:2:2*n) = 4 * yt(2:2:2*n);
yt(3:2:2*n-1) = 2 * yt(3:2:2*n-1);
y = h / 6 * sum(yt);

end

