clear all
close all
clc

rowsA = 3;
colsA = 1;
rowsB = 1;
colsB = 3;
maxRand = 10;

A = randi(maxRand,rowsA,colsA);
B = randi(maxRand,rowsB,colsB);
     
C = A*B;

csvwrite('A.csv',A'(:));
csvwrite('B.csv',B'(:));
csvwrite('C.csv',C'(:));