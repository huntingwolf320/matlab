function [  ] = compress(  )
img = imread('动物照片.jpg');
[row,col,~] = size(img);
n = 8;

%提取RGB通道
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

%RGB转换为YUV
Y = 0.299*double(R)+0.587*double(G)+0.114*double(B);
U = -0.169*double(R)-0.332*double(G)+0.5*double(B);
V = 0.5*double(R)-0.419*double(G)-0.081*double(B);

%扩展YUV矩阵使长宽的像素都为16的倍数
Y = extend(Y,16);
U = extend(U,16);
V = extend(V,16);

%4:2:0二次取样
U = blockproc(U,[2 2],@(block) block.data(1,1));
V = blockproc(V,[2 2],@(block) block.data(2,2));

%2D DCT变换
A = zeros(n);
for i = 0:n-1
    for j = 0:n-1
        if i == 0
            a = sqrt(1/n);
        else
            a = sqrt(2/n);
        end
        A(i+1,j+1) = a*cos((j+0.5)*pi*i/n);
    end
end
fun1 = @(block) A*block.data*A';
DCTY = blockproc(Y,[n n],fun1);
DCTU = blockproc(U,[n n],fun1); 
DCTV = blockproc(V,[n n],fun1); 

%亮度量化表
btable = [
16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 55;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77; 
24 35 55 64 81 104 113 92;                      
49 64 78 87 103 121 120 101;                   
72 92 95 98 112 100 103 99;
]; 
%色度量化表
ctable = [
17 18 24 47 99 99 99 99; 
18 21 26 66 99 99 99 99; 
24 26 56 99 99 99 99 99; 
47 66 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99; 
99 99 99 99 99 99 99 99;
];
%量化 
QY = blockproc(DCTY,[n n],@(block)round(block.data./btable));
QU = blockproc(DCTU,[n n],@(block)round(block.data./ctable)); 
QV = blockproc(DCTV,[n n],@(block)round(block.data./ctable));

%进行DC、AC系数的DPCM编码和游长编码以及熵编码等无损编码算法，返回编码位数（KB）
code(QY,8)+code([QU QV],8)

%反量化
NQY = blockproc(QY, [n n], @(block) block.data.*btable);
NQU = blockproc(QU, [n n], @(block) block.data.*ctable);
NQV = blockproc(QV, [n n], @(block) block.data.*ctable);

%反DCT变换
fun2 = @(block) A'*block.data*A;
IDCTY = blockproc(NQY,[n n],fun2);
IDCTU = blockproc(NQU,[n n],fun2); 
IDCTV = blockproc(NQV,[n n],fun2);

%反二次取样的补全
IDCTU = blockproc(IDCTU,[1 1],@(block) ones(2,2)*block.data(1,1));
IDCTV = blockproc(IDCTV,[1 1],@(block) ones(2,2)*block.data(1,1));

%还原源图片大小
IDCTY = IDCTY(1:row,1:col);
IDCTU = IDCTU(1:row,1:col);
IDCTV = IDCTV(1:row,1:col);

%将YUV转为RGB
RI = IDCTY-0.001*IDCTU+1.402*IDCTV;
GI = IDCTY-0.344*IDCTU-0.714*IDCTV; 
BI = IDCTY+1.772*IDCTU+0.001*IDCTV;

%重新生成图像 
RGBI = uint8(cat(3,RI,GI,BI));
loss = sum(sum(sum((img-RGBI).^2)))/(prod(size(img))) %计算自编的JPEG算法的失真度
%imshow(RGBI);
%imwrite(RGBI,'jpegPhoto.jpg');
end

%扩展函数
function [x] = extend(x,n)
[row,col] = size(x);
row_expand = ceil(row/n)*n;
if mod(row,n) ~= 0
    for i = row:row_expand
        x(i,:,:) = x(row,:,:);
    end
end
col_expand = ceil(col/n)*n;
if mod(col,n) ~= 0        
    for i = col:col_expand
        x(:,i,:) = x(:,col,:);
    end
end
end

%VLI编码表函数
%求组号函数，输入x值返回x在VLI编码表中的组号
function [group] = vligroup(x)
    if x == 0
        group = 0;
    else
        for i = 1:15
            if abs(x)<2^i
                group = i;
                break;
            end
        end
    end
end
%求对应编码函数，输入x值以及相应的组号，返回x在VLI编码表中的布尔编码值
function [code] = vlicode(x,group)
    if x == 0
        code = [];
    else
        code = [logical(true) logical(dec2bin(abs(x)-2^(group-1))-48)]';
        if x<0
            code = ~code;
        end
    end
end

%哈夫曼编码函数，输入频数分布，返回哈夫曼编码后对应的码字，以及子长
function [ num,y ] = huffman_code( x )
% y为各个频数的码字，以布尔矩阵存储，其中num指明取最右边多少位为有效码字
    x = x/sum(x);
    n = length(x);
    y = logical(zeros(n,n));
    num = zeros(n,1);
    set = zeros(n,n);
    set(1,:) = 1:n;
    nx = x;

    for time = 1:n-1
        [nx index] = sort(nx);
        set = set(:,index(:));
        for i = 1:sum(set(:,1)~=0)
            y(set(i,1),n-num(set(i,1))) = true;
            num(set(i,1)) = num(set(i,1)) + 1;
        end
        for i = 1:sum(set(:,2)~=0)
            num(set(i,2)) = num(set(i,2)) + 1;
        end

        temp = set(:,1:2);
        temp(temp==0) = [];
        temp = [temp,zeros(1,n-size(temp,2))]';
        set(:,2) = [];
        set(:,1) = temp;

        nx = [nx(1)+nx(2);nx(3:end)];
    end
end

%进行DC、AC系数的DPCM编码和游长编码以及熵编码等无损编码的函数
function [total] = code(x,n)
%z字型扫描表
ztable = [
    1  9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
    41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
    43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
    45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
    62 63 56 64];

y = im2col(x, [n n], 'distinct');
y = y(ztable, :);

blocknum = size(y,2);

%DC系数的DPCM编码
DC = y(1,:)';
DC = DC-[0;DC(1:blocknum-1)];

%DC系数的哈夫曼编码（熵编码）
%得到DC系数中size的哈夫曼查找表
DCgroup = zeros(blocknum,1);
for i = 1:blocknum
    DCgroup(i) = vligroup(DC(i));    
end
T1 = tabulate(DCgroup);
[hn1 hc1] = huffman_code(T1(:,2));

%AC系数的游长编码
len = zeros(numel(x)+blocknum,1);
siz = zeros(numel(x)+blocknum,1);
count = 1;
for i = 1:blocknum
    index = find(y(2:end, i));
    for j = 1:size(index,1)
        if j == 1
            len(count) = index(j)-1;
            siz(count) = y(index(j)+1,i);
        else
            if index(j)-index(j-1)>16
                for k = 0:floor((index(j)-index(j-1)-1)/16)
                    len(count) = 15;
                    siz(count) = 0;
                    count = count+1;
                end
            end
            len(count) = mod(index(j)-index(j-1)-1,16);
            siz(count) = y(index(j)+1,i);
        end
        count = count+1;
    end
    % 加入块结束标志
    len(count) = 0;
    siz(count) = 0;
    count = count+1; 
end
len(count:end) = []; 
siz(count:end) = [];

%AC系数的哈夫曼编码（熵编码）
%得到symbol1系数的哈夫曼查找表
ACgroup = zeros(count-1,1);
for i = 1:blocknum
    ACgroup(i) = vligroup(siz(i));    
end
symbol = len*16+ACgroup;
T2 = tabulate(symbol);
[hn2 hc2] = huffman_code(T2(:,2));

%计算压缩完成的最终比特位数
%DC系数哈夫曼编码所占的比特位数
DCtotal = sum(hn1.*T1(:,2)) + sum(T1(:,1).*T1(:,2));
ACtotal = sum(hn2.*T2(:,2)) + sum(T2(:,1).*T2(:,2));
total = (DCtotal+ACtotal)/8/1024;

end
