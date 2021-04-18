function save_currentfig (savepath, name)
% save_cfig (savepath, name) saves the opened figures in 'savepath' and
% closes them

h =  findobj('type','figure');
n = length(h);

for ii = 1:n
   namefile = strcat(name, '_',num2str(h(ii).Number),'.jpg'); 
%    saveas(h(ii), [savepath, name, 'jpg'],'jpg')
   saveas(h(ii), fullfile(savepath, namefile))

   close(h(ii))
end

%% Created: 07/02/21
% Debugged: 23/02/21
