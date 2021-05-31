function  [B]= BoxPloting(AvrgROIsWavesI,titulo)
%BOXPLOTING Summary of this function goes here
%   Detailed explanation goes here
row=size( AvrgROIsWavesI,1);
colum=size( AvrgROIsWavesI,2);
threeD=size( AvrgROIsWavesI,3);
P=[1 2 3 4 5 6]
names = {'dm4M'; 'dm4L'; 'dm3'; 'dm1'; 'dm2';'dld'};

for i=1:colum
   A =  AvrgROIsWavesI(1,i,:);
   A=squeeze(A);
   B(:,i)=A
end 
boxplot(B,names)
hold on 
plot(mean(B))
plot(mean(B),'k.','MarkerSize',30)
title(titulo)
ylabel('∆F/ms','FontSize',20)
set(gca,'xtick',[1:6],'xticklabel',names,'FontSize',20)
end
