function [ x ] = gassian_elimination( A,b )
%高斯消元法
%16340108 黎浩良 2018/05/14
    [col,row] = size(A);
    n = length(b);
    if row ~= col || n ~= row
        disp("请输入正确的n*n方阵A,以及n维向量b")
        return
    end
    x = zeros(n,1);
    %转化成上三角矩阵
    for i = 1:n - 1
        for j = i + 1:n
            if A(i,i) == 0
                disp("错误：矩阵的顺序主子式有零值")
                return 
            end
            m = A(j,i)/A(i,i);
            for l = i + 1:n
                A(j,l) = A(j,l) - m*A(i,l);
            end
            b(j) = b(j)-m*b(i);
        end
    end
    %回代求解
    for i = n:-1:1
        for j = i + 1:n
            b(i) = b(i) - A(i,j)*x(j);
        end
        x(i) = b(i)/A(i,i);
    end
end

