function [control_codes]= force0ending(cond_codes)
% [control_codes]= turn_into_control(cond_code)

% Output the number forcing it to finish in 0 

for i = length(cond_codes)
    strcode = num2str(cond_codes(i));
    newcode = strcode; 
    newcode(end) = '0';
    control_codes(i) = str2num(newcode);
    clear strcode newcode
end
end