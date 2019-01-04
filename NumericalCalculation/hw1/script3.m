file = importdata('soc-Epinions1.txt');
data = file.data;

count = 75888;
steps = 100;
d = 0.85;
[ pr,err ] = pagerank( count,data,d,steps );
figure;
plot(1:steps, err);
figure;
plot(1:count, pr);


