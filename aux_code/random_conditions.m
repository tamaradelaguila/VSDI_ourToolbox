%% GENERATE RANDOM ORDER OF STIMULUS PRESENTATION
j= 0;
n_cond = 5; % 3 intensities + no-stimulus

nrep= 40;

for i = 1:nrep
temp = 0:n_cond-1; temp = temp(randperm(n_cond, n_cond));
sample(j+1:n_cond*i) = temp;
j = j+n_cond;
end

sample = sample';

excelname = '/home/tamara/Documents/MATLAB/protocol.xls';
sheetname = [num2str(n_cond), 'cond'] ; % cada hoja se llamará como el pez
writematrix (sample,excelname,'Sheet',sheetname) %imprimos todas las filas y columnas de ese pez

% length(find(sample==0))

% randsample = sample(randperm(length(sample))); 
% length(find(randsample==4))

% randsample = randsample';