
VSDroiTS = TORus('loadwave',8); 
waves = VSDroiTS.filt306.data;


cond_code = unique(VSDI.condition(:,1)); cond_code = cond_code(~isnan(cond_code));

sel_tri= find(VSDI.condition==1001);
waves2=waves(:,:,sel_tri);

 saverute='C:\Users\davi9\OneDrive\Escritorio\Figura1Graficas'
 
 %% SLOPE

 for i=1:size(waves2,3)
    Onda= squeeze(waves2(:,:,i));
    Slope=DerivativeVSDI(Onda); % es lo mismo que diff(Onda)./5. ¿por qué lo divides?
    SlopeWaves(:,:,i)=Slope;
    
    Slope2 = diff(Onda)./5;
end

for i=1:size(SlopeWaves,3)
    Slp= squeeze(SlopeWaves(:,:,i));
    [SlopeR] = RecorteSlope(Slp,[61:101]) ;%GeneralMaxi(1)
    SlopeRVSDI(:,:,i)=SlopeR;
end


for i=1:size(SlopeRVSDI,3)
    Avrg= squeeze(SlopeRVSDI(:,:,i));
    [AvrgROIs] = AverageSlope(Avrg);
    AvrgROIsWavesI(:,:,i)=AvrgROIs;
end

for i=1:size(AvrgROIsWavesI,3)
    PotROI= squeeze(AvrgROIsWavesI(:,:,i));
    DotPlotting(PotROI,'Slope: Estimulo cola100us 1x10 #210201')
end

[B]=BoxPloting(AvrgROIsWavesI,'Slope: Estimulo cola 100us 1x10 #210201');
[Decision,ValorS] = StatisticalAnalysis(B)

%% AMPLITUD
size(waves2,3)

for i=1:size(waves2,3)
    Onda= squeeze(waves2(:,:,i));
    Onda=Onda([61:101],:)
     [MaxiMini] = MAXIMINVSDI(Onda);
    MAXMIN(:,:,i)=MaxiMini;
end

for i=1:size(MAXMIN,3)
%     for j=1:size(MAXMIN,2)
        Amplitud(:,:,i)=abs(MAXMIN(1,:,i)-MAXMIN(2,:,i));
end 

for i=1:size(Amplitud,3)
    AmplitudROI= squeeze(Amplitud(:,:,i));
    DotPlotting(AmplitudROI,'AmplitudEstimulo detrás operculo 100us 1x10 #210201')
%     AvrgROIsWavesI(:,:,i)=AvrgROIs;
end


%% Latencia
% latencia

for i=1:size(SlopeWaves,3)
    Slp= squeeze(SlopeWaves(:,:,i));
    [SlopeRLineaB] = RecorteSlope(Slp,[1:60]) %GeneralMaxi(1)
    SlopeRVSDIBaseLine(:,:,i)=SlopeRLineaB;
end

for i=1:size(SlopeRVSDIBaseLine,3)
    Baseline=squeeze(SlopeRVSDIBaseLine(:,:,i));
    tempBaseLine=mean(Baseline);
    SlopeBaseLine(:,:,i)=tempBaseLine;
end  

for  i=1:size(SlopeBaseLine,3)
    for j=1:size(SlopeBaseLine,2)
        A=find(SlopeWaves(:,j,i)>AvrgROIsWavesI(:,j,i)*0.5)
    end 
end 

SlopeBaseLine(:,j,i)*0.05+SlopeBaseLine(:,j,i))

[filas colum]=size(Velocity)
for j=1:filas
BaseLineVelocity(j,:)=Velocity(j,1:500);
end 
BaseLineAveVelocity=mean(BaseLineVelocity,2);
for jj=1:filas
A=find(Velocity(jj,:)>BaseLineAveVelocity(jj)*0.20+BaseLineAveVelocity(jj))
latency(jj)=abs(A(1)-300);

end

  
waves2([61:100],6,:)