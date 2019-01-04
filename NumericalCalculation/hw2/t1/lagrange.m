function [ y ] = lagrange( xArr, yArr, x )
% 拉格朗日插值法通用函数
% xArr为已知节点横坐标集合，xArr为纵坐标集合
% （x，y)为待求点
    n = length(xArr);
    y = 0; 
    c1 = ones(n-1,1);
    for i=1:n
      xp = xArr([1:i-1 i+1:n]);
      xp = xp';
      y = y + yArr(i) * prod((x*c1 - xp)./(xArr(i)*c1 - xp));
    end
end

