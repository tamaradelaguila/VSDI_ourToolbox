function [] = blob()
t = linspace(0, .1, 3.8E+3);
f0 =   200;
f1 = 1000;
Fs = 1/mean(diff(t));
x = chirp(t,f0,t(end),f1);
sound(x, Fs)
end