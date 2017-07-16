clc;close all;clear all
x0=[0 3];
x1=[-3 0];
x2=[3 0];
sigma=[2 1;1 2];
syms x y
pos=[x y];
fun1=(pos-x0)*sigma*(pos-x0).';
fun2=(pos-x1)*sigma*(pos-x1).';
fun3=(pos-x2)*sigma*(pos-x2).';
figure;h1=ezplot(fun1-fun2);
hold on;axis equal
set(h1,'Color','m')
h2=ezplot(fun1-fun3);
set(h2,'Color','r')
h3=ezplot(fun3-fun2);
set(h3,'Color','g')

figure;h1=ezplot(fun1-fun2+10);
hold on;axis equal
set(h1,'Color','m')
h2=ezplot(fun1-fun3+10);
set(h2,'Color','r')
h3=ezplot(fun3-fun2+10);
set(h3,'Color','g')