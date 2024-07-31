clear; close all;
%% Input data
sz = 100;   %# of sample size
var = 2;    %# of variables
eps = linspace(0,1,sz);
eps_d = linspace(1,10,sz);
T = linspace(1000,1300,sz);
[eps, eps_d, T] = ndgrid (eps, eps_d, T);
k = 646; n = 0.227; m = 0.01;
sig = k * (1+eps).^n .* eps_d.^m .* (1-T/1500);% + 10*rand(var,sz);
%% Train the NN
x = [eps(:) eps_d(:) T(:)]';
y = sig(:)';
% nn = 1;
net = feedforwardnet([5 5 10]);
% net = cascadeforwardnet(nn);
[net,tr] = train(net,x,y);
%% Exctract the trained NN
genFunction(net,'netFcn');
%% Test the NN
eps_test = .35;%linspace(0,1,sz);
eps_d_test = 10; %linspace(0,1,sz/10);
T_test = 1200;
[eps_test, eps_d_test, T_test] = ndgrid (eps_test, eps_d_test, T_test);
x = [eps_test(:) eps_d_test(:) T_test(:)]';
% y_NN = net(x);
y_NN = netFcn(x);
%% Visualize the comparison
% y_NN = netFcn(x);
eps = linspace(0,1,sz);
sig = k * (1+eps).^n .* eps_d_test.^m .* (1-T_test/1500);% + 10*rand(var,sz);
figure;
plot(eps,sig,'-');
hold on
plot(eps_test,y_NN,'*');
