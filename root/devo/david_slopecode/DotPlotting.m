function  DotPlotting(AverageSlopeR,titulo)
%DOTPLOTTING Summary of this function goes here
%   Detailed explanation goes here
c={'r.','b.','k.','g.','y.','c.'}
P=[1 2 3 4 5 6]
[row colum]=size(AverageSlopeR);
for ii=1:colum
 plot(P(ii),AverageSlopeR(:,ii),c{ii},'MarkerSize',30)
hold on
end 
title(titulo)
ylabel('Slope','FontSize',20)
names = {'dm4M'; 'dm4L'; 'dm3'; 'dm1'; 'dm2';'dld'};
set(gca,'xtick',[1:6],'xticklabel',names,'FontSize',20)

end

