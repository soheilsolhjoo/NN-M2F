clear all; clc;
seed_file_name = 'netFcn.m';
%% Read the netFcn.m file
fid = fopen(seed_file_name,'r');
netFcn = textscan(fid,'%s','whitespace','','delimiter','\n');
netFcn = netFcn{:};
fclose(fid);
%% Find the number of hidden layers
idx = find(strcmp(netFcn, '% Output 1'));
idx = idx - 4;
L_fin = netFcn{idx};
idx = ismember(L_fin, '% Layer ');
L_fin(idx) = [];
L_fin = str2num(L_fin);
%% Collect the network constants
%x_step
idx = find(strcmp(netFcn, '% Input 1'));
for i = 1:3
    x_step(i) = read_data(netFcn{idx+i});
end

%y_step
idx = find(strcmp(netFcn, '% Output 1'));
for i = 1:3
    y_step(i) = read_data(netFcn{idx+i});
end

% Layers
idx = find(strcmp(netFcn, '% Layer 1'));
const{L_fin,2} = {};
for i = 1:L_fin
    const{i,1} = read_data(netFcn{idx+1});  %b
    const{i,2} = read_data(netFcn{idx+2});  %W
    idx = idx + 4;
end
%% Prepare for writing a Fortran subroutine
% Header
text{1,1}   = '      include ''NN_funcs.f'' ';
text{2,1}   = '      subroutine NN_mat(stress,strain)';
text{3,1}   = '      use NN_funcs';
text{4,1}   = '#ifdef _IMPLICITNONE';
text{5,1}   = '      implicit none';
text{6,1}   = '#else';
text{7,1}   = '      implicit logical (a-z)';
text{8,1}   = '#endif';
% Definer
text{9,1}   = '      real*8 x_xoffset, x_gain, x_ymin';
text{10,1}  = '      real*8 y_xoffset, y_gain, y_ymin';
text{11,1}  = '      real*8 a0, strain';
text{12,1}  = '      real*8, dimension(1) :: stress';
idx = size(text,1);
formatL1    = '      real*8, dimension(%i,1) :: b%i, a%i';
formatL2    = '      real*8, dimension(%i,%i) :: W%i';
Layers_size(1) = 1;
Layers_size(L_fin+1) = 1;
for i=2:L_fin
    Layers_size(i) = size(const{i-1},1);
    text{idx+1,1} = sprintf(formatL1,Layers_size(i),i-1,i-1);
    text{idx+2,1} = ...
        sprintf(formatL2,Layers_size(i),Layers_size(i-1),i-1);
    idx = idx + 2;
end
formatL1    = '      real*8, dimension(%i) :: b%i, a%i';
formatL2    = '      real*8, dimension(%i) :: W%i';
text{idx+1,1} = sprintf(formatL1,Layers_size(L_fin+1),i,i);
text{idx+2,1} = sprintf(formatL2,Layers_size(i),i);
% Steps (x and y)
idx = size(text,1);
text{idx+1,1} = ['      x_xoffset = ', num2str(x_step(1))];
text{idx+2,1} = ['      x_gain = ', num2str(x_step(2))];
text{idx+3,1} = ['      x_ymin = ', num2str(x_step(3))];
text{idx+4,1} = ['      y_xoffset = ', num2str(y_step(1))];
text{idx+5,1} = ['      y_gain = ', num2str(y_step(2))];
text{idx+6,1} = ['      y_ymin = ', num2str(y_step(3))];
% bs and Ws
idx = size(text,1);
formatLbW    = '      data %s%i / %s /';
for i=1:L_fin
    b_string = sprintf('%.20f, ' , const{i,1}');
    b_string = b_string(1:end-2);
    W_temp = const{i,2};
    W_string = sprintf('%.20f, ' , W_temp(:)');
    W_string = W_string(1:end-2);
    
    text{idx+1,1} = sprintf(formatLbW,'b',i,b_string);
    text{idx+2,1} = sprintf(formatLbW,'W',i,W_string);
    idx = idx + 2;
end
% Simulation Section
idx = size(text,1);
text{idx+1,1}   = ...
    '      a0 = mapminmax_apply(strain, x_xoffset, x_gain, x_ymin)';
formatLa    = '      a%i = tansig_apply(b%i+W%i*a%i,%i,%i)';
idx = size(text,1);
for i=1:L_fin-1
    text{idx+1,1} = sprintf(formatLa,i,i,i,i-1,Layers_size(i+1),1);
    idx = idx + 1;
end
formatLafin = '      a%i = b%i + matmul(W%i,a%i)';
text{idx+1,1} = sprintf(formatLafin,L_fin,L_fin,L_fin,i);
formatLY    = ...
    '      stress = mapminmax_reverse(a%i, y_xoffset, y_gain, y_ymin, 1)';
text{idx+2,1} = sprintf(formatLY,L_fin);
% Ending
idx = size(text,1);
text{idx+1,1}   = '      return';
text{idx+2,1}   = '      end';
%% Write down the subroutine file named NN_mat.f
fid = fopen('NN_mat.f','w');
for i = 1:size(text,1)
    fprintf(fid,'%s\n',text{i});
end
fclose(fid);