n = [5 9 17 33];
y = zeros(1, 4);
for i=1:4
    y(i) = compound(0,1,n(i),@(x)sin(x)/x)
end
plot(n,y);