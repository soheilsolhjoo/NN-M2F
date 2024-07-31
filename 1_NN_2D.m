clear; close all;
%% Input data
sz = 100;   %# of sample size
var = 2;    %# of variables
eps = linspace(0,1,sz);
eps_d = linspace(1,10,sz);
[eps, eps_d] = ndgrid (eps, eps_d);
k = 646; n = 0.227; m = 0.01;
sig = k * (1+eps).^n .* eps_d.^m;% + 10*rand(var,sz);
%% Train the NN
x = [eps(:) eps_d(:)]';
y = sig(:)';
% nn = 1;
net = feedforwardnet([5]);
% net = cascadeforwardnet(nn);
[net,tr] = train(net,x,y);
%% Exctract the trained NN
genFunction(net,'netFcn');
%% Test the NN
eps_test = .35;%linspace(0,1,sz);
eps_d_test = 10; %linspace(0,1,sz/10);
[eps_test, eps_d_test] = ndgrid (eps_test, eps_d_test);
x = [eps_test(:) eps_d_test(:)]';
% y_NN = net(x);
y_NN = netFcn(x);
%% Visualize the comparison
% y_NN = netFcn(x);
eps = linspace(0,1,sz);
sig = k * (1+eps).^n .* eps_d_test(1).^m;% + 10*rand(var,sz);
figure;
plot(eps,sig,'-');
hold on
plot(eps_test,y_NN,'*');
