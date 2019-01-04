Atest = [1 3 4;
        16 -2 -3;
        10 3 1];
btest = [2; 3; 6];
result = Atest\btest
gresult = gassian_elimination(Atest,btest)
cresult = col_elimination(Atest,btest)

n = [10 50 100 200];
gtime = zeros(1,length(n));
ctime = zeros(1,length(n));
for i = 1:length(n)
    A = normrnd(0,1,n(i),n(i));
    b = normrnd(0,1,n(i),1);
    
    tic
    gassian_elimination(A,b);
    gtime(i) = toc;
    
    tic
    col_elimination(A,b);
    ctime(i) = toc;
end
plot(n,gtime,n,ctime)