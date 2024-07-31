function number = read_data(string)
%read_data
idx_temp1 = ismember(string, '=');
idx_temp2 = find(idx_temp1,1);
idx_temp1(1:idx_temp2) = 1;
string(idx_temp1) = [];
number = str2num(string);
end