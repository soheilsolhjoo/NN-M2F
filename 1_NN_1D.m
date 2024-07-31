clear; close all;
%% Input data
sz = 100;   %# of sample size
var = 1;    %# of variables
eps = linspace(0,1,sz);
k = 646; n = 0.227;
sig = k * (1+eps).^n;% + 10*rand(var,sz);
%% Train the NN
x = eps(:)';
y = sig(:)';
nn = 3;
net = feedforwardnet([4 3 2]);
% net = cascadeforwardnet(nn);
[net,tr] = train(net,x,y);
%% Exctract the trained NN
genFunction(net,'netFcn');
%% Test the NN
eps_test = .35;%linspace(0,1,sz/10);
x = eps_test(:)';
% y_NN = net(x);
y_NN = netFcn(x);
%% Visualize the comparison
% y_NN = netFcn(x);
figure;
plot(eps,sig,'-');
hold on
plot(eps_test,y_NN,'*');
