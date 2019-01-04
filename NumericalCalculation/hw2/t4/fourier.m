function [  ] = fourier()
%快速傅里叶变换
    %生成若干正弦波混杂的信号，以及设定点数
    N=1024;        %点数1024
    t=0:1/N:N-1/N; 
    x=sin(2*pi*543*t) + sin(2*pi*100*t) + 0.2 + sin(2*pi*857*t) + sin(2*pi*222*t); %原始信号            
    y=fft(x,N);%标准快速傅里叶变换
    %自编程序
    A1 = x;
    A2 = x;
    w = zeros(1, N/2);
    p = log2(N);
    for m = 0:N/2-1
        w(m+1) = exp(-2*pi*m*1i/N);
    end
    for q = 1:p
        if mod(q,2) == 1
            for k = 0:2^(p-q)-1
                for j = 0:2^(q-1)-1
                    A2(k*2^q + j + 1) = A1(k*2^(q-1) + j + 1) + A1(k*2^(q-1) + j + 2^(p-1) + 1);
                    A2(k*2^q + j + 2^(q-1) + 1) = (A1(k*2^(q-1) + j + 1) - A1(k*2^(q-1) + j + 2^(p-1) + 1)) * w(k*2^(q-1) + 1);
                end
            end
        else
            for k = 0:2^(p-q)-1
                for j = 0:2^(q-1)-1
                    A1(k*2^q + j + 1) = A2(k*2^(q-1) + j + 1) + A2(k*2^(q-1) + j + 2^(p-1) + 1);
                    A1(k*2^q + j + 2^(q-1) + 1) = (A2(k*2^(q-1) + j + 1) - A2(k*2^(q-1) + j + 2^(p-1) + 1)) * w(k*2^(q-1) + 1);
                end
            end
        end
    end
    if mod(p, 2) == 0
        A = A1;
    else
        A = A2;
    end
    %结果比较
    subplot(2,1,1);
    plot(0:N/2-1,abs(y(1:N/2))); %标准傅里叶变换后幅频特性
    subplot(2,1,2);
    plot(0:N/2-1,abs(A(1:N/2))); %自实现的傅里叶变换后幅频特性
end

