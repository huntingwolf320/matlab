
n = [10 50 100 200];
jtime = zeros(1,length(n));
gtime = zeros(1,length(n));
ltime = zeros(1,length(n));
ctime = zeros(1,length(n));

g_etime = zeros(1,length(n));
c_etime = zeros(1,length(n));

%{
for i = 1:length(n)
    D = diag(rand(n(i),1));
    U = orth(rand(n(i),n(i)));
    A = U' * D * U;
    b = normrnd(0,1,n(i),1);
    
    x0 = zeros(n(i),1);    
    steps = 100;  
    
    tic
        [x1,err1] = jacobi_iteration(A,b,x0,steps);
    jtime(i) = toc;
    
    tic
        [x2,err2] = gauss_seidel_iteration(A,b,x0,steps);
    gtime(i) = toc;
    
    w = 1.5;
    tic
        [x3,err3] = loose_iteration(A,b,x0,steps,w);
    ltime(i) = toc;
    
    tic
        [x4,err4] = conjugate_gradient(A,b,x0,steps);
    ctime(i) = toc;
    
    tic
    gassian_elimination(A,b);
    g_etime(i) = toc;
    
    tic
    col_elimination(A,b);
    c_etime(i) = toc;
    %各迭代法的收敛曲线
    figure;
    plot(1:steps, err1 , 1:steps, err2, 1:steps, err3, 1:steps, err4);
end

%时间比较曲线
figure;
plot(n,jtime,n,gtime,n,ltime,n,ctime,n,g_etime,n,c_etime);
%}

%-----------------------------------------------------------------

%测试松弛因子变化对收敛速度的影响
size = 50;
D = diag(rand(size,1));
U = orth(rand(size,size));
A = U' * D * U;
b = normrnd(0,1,size,1);

steps = ones(1,19);
index = 1;

for w =0.1:0.1:1.9
    x0 = zeros(size,1); 
    [x0,err] = loose_iteration(A,b,x0,1,w);
    while err(1) > 0.001
        [x0,err] = loose_iteration(A,b,x0,1,w);
        steps(index) = steps(index) + 1;
    end
    index = index + 1;
end

figure;
plot(0.1:0.1:1.9, steps);


