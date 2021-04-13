function rasterCompareAnatomy(polyInnerCtl,polyOuterCtl,regionPolyCVLCtl,regionLinesCVLCtl,imBgCtl,polyInnerExp,polyOuterExp,regionPolyCVLExp,regionLinesCVLExp,imBgExp)
% RASTERCOMPAREANATOMY uses the polygonal geometries and user-drawn
% anatomical boundary lines (all created using RASTERIZEMAIN) to compare
% anatomical features between control and experimental groups of slices.
% Statistical comparisons are conducted for each region using a t-test.
% The means and standard deviations for each group and p-values for 
% statistical comparisons are displayed in the command window.  An "h" 
% value is displayed to indicate whether or not to reject the null
% hypotheses (that the means of the two groups are equal) at the alpha=0.05
% significance level. H=1 indicates that the null hypothesis can be 
% rejected.  A plot is also generated to show the distribution of the 
% values for each anatomical parameter.
%
% Example command to run RASTERCOMPAREANATOMY:
% rasterCompareAnatomy(polyInnerWT,polyOuterWT,regionPolyCVLWT,regionLinesCVLWT,imBgWT,polyInnerArxDlx,polyOuterArxDlx,regionPolyCVLArxDlx,regionLinesCVLArxDlx,imBgArxDlx)
%
%
% Inputs:
% 
% ** ALL inputs to RASTERCOMPAREANATOMY are cell arrays. **
% 
% The cell arrays polyInnerCtl, polyOuterCtl, regionPolyCVLCtl, 
% regionLinesCVLCtl, and imBgCtl are all the same size (Nx1), and each 
% "ith" cell of all of these arrays corresponds to control slice number i.
% (There are N total slices in the control group.)
%
% In the same manner, the cell arrays polyInnerExp, polyOuterExp, 
% regionPolyCVLExp, regionLinesCVLExp, and imBgExp are all the same size 
% (Mx1).  (There are M total slices in the experimental group.)
%
% polyInnerCtl: A cell array of size Nx1, where each cell contains 
% the inner-arc polygonal geometry for a control slice.  (polyInnerCtl{1} 
% is a cell array where each cell describes a single polygon of the 
% polygonal geometry.)
%
% polyOuterCtl: Similar to polyInnerCtl, polyOuterCtl is a cell array of 
% size Nx1, where each cell contains the outer-arc polygonal geometry 
% for a control slice.
%
% regionPolyCVLCtl: Each cell contains the user-drawn polygon for the CA 
% region of a single control slice.  Like all the other inputs, this is a 
% nested cell array.
%
% regionLinesCVLCtl: Each cell contains the user-drawn lines (midline and 
% hatch marks identifying the hilus/CA3 transition and the CA3/CA1
% transition) for a single control slice.  Like all the other inputs, this
% is a nested cell array.
%
% imBgCTL: Nx1 cell array.  Each cell contains an image (raw camera frame) 
% of a slice.
%
% The remaining variables are for the experimental group, and are of the
% same format as the variables described above, for the control group.
% Specifically:
%
% polyInnerExp: same format as polyInnerCtl.
% polyOuterExp: same format as polyOuterCtl
% regionPolyCVLExp: same format as regionPolyCVLCtl
% regionLinesCVLExp: same format as regionLinesCVLCtl
% imBgExp: same format as imBgCtl
%


% Assign variable names that correspond to the specific anatomies of 
% interest: inner regions are radiatum, outer regions are oriens.  
polyRadCtl = polyInnerCtl;
polyOrCtl = polyOuterCtl;
polyRadExp = polyInnerExp;
polyOrExp = polyOuterExp;


% measure anatomical parameters for control and experimental groups
[lenHilCtl,lenCA3Ctl,lenCA1Ctl,areaHilRadCtl,areaHilOrCtl,areaCA3radCtl,areaCA3orCtl,areaCA1radCtl,areaCA1orCtl]=rasterMeasureAnatomy(polyRadCtl,polyOrCtl,regionPolyCVLCtl,regionLinesCVLCtl,imBgCtl,0);
[lenHilExp,lenCA3Exp,lenCA1Exp,areaHilRadExp,areaHilOrExp,areaCA3radExp,areaCA3orExp,areaCA1radExp,areaCA1orExp]=rasterMeasureAnatomy(polyRadExp,polyOrExp,regionPolyCVLExp,regionLinesCVLExp,imBgExp,0);


disp('Length of cell body layer (mm): ')
[meanPyrLenNoHilusCtl,stdPyrLenNoHilusCtl,meanPyrLenNoHilusExp,stdPyrLenNoHilusExp,hPyrLenNoHilus,pPyrLenNoHilus] = paramStats(lenCA3Ctl+lenCA1Ctl,lenCA3Exp+lenCA1Exp,1);
% disp('Length of hilus (mm): ')
% [meanHilLenCtl,stdHilLenCtl,meanHilLenExp,stdHilLenExp,hHilLen,pHilLen] = paramStats(lenHilCtl,lenHilExp,1);
% disp('Length of CA3 (mm): ')
% [meanCA3LenCtl,stdCA3LenCtl,meanCA3LenExp,stdCA3LenExp,hCA3Len,pCA3Len] = paramStats(lenCA3Ctl,lenCA3Exp,1);
% disp('Length of CA1 (mm): ')
% [meanCA1LenCtl,stdCA1LenCtl,meanCA1LenExp,stdCA1LenExp,hCA1Len,pCA1Len] = paramStats(lenCA1Ctl,lenCA1Exp,1);
% disp('Length of hippocampus (including hilus, mm): ')
% [meanHippoLenCtl,stdHippoLenCtl,meanHippoLenExp,stdHippoLenExp,hHippoLen,pHippoLen] = paramStats(lenHilCtl+lenCA3Ctl+lenCA1Ctl,lenHilExp+lenCA3Exp+lenCA1Exp,1);


disp('Area of hippocampus (mm^2): ')
paramStats(areaHilRadCtl+areaHilOrCtl+areaCA3radCtl+areaCA3orCtl+areaCA1radCtl+areaCA1orCtl,areaHilRadExp+areaHilOrExp+areaCA3radExp+areaCA3orExp+areaCA1radExp+areaCA1orExp,1);
% disp('Area of stratum radiatum (mm^2): ')
% paramStats(areaHilRadCtl+areaCA3radCtl+areaCA1radCtl,areaHilRadExp+areaCA3radExp+areaCA1radExp,1);
% disp('Area of stratum oriens (mm^2): ')
% paramStats(areaHilOrCtl+areaCA3orCtl+areaCA1orCtl,areaHilOrExp+areaCA3orExp+areaCA1orExp,1);

% disp('Area of hilus (mm^2): ')
% paramStats(areaHilRadCtl+areaHilOrCtl,areaHilRadExp+areaHilOrExp,1);
% disp('Area of CA3 (mm^2): ')
% paramStats(areaCA3radCtl+areaCA3orCtl,areaCA3radExp+areaCA3orExp,1);
% disp('Area of CA1 (mm^2): ')
% paramStats(areaCA1radCtl+areaCA1orCtl,areaCA1radExp+areaCA1orExp,1);
% 
% disp('Area of hilus radiatum (mm^2): ')
% paramStats(areaHilRadCtl,areaHilRadExp,1);
% disp('Area of CA3 radiatum (mm^2): ')
% paramStats(areaCA3radCtl,areaCA3radExp,1);
% disp('Area of CA1 radiatum (mm^2): ')
% paramStats(areaCA1radCtl,areaCA1radExp,1);
% 
% disp('Area of hilus oriens (mm^2): ')
% paramStats(areaHilOrCtl,areaHilOrExp,1);
% disp('Area of CA3 oriens (mm^2): ')
% paramStats(areaCA3orCtl,areaCA3orExp,1);
% disp('Area of CA1 oriens (mm^2): ')
% paramStats(areaCA1orCtl,areaCA1orExp,1);

figure(301)
ax1 = subplot(1,2,1);
dotPlot(lenCA3Ctl+lenCA1Ctl,lenCA3Exp+lenCA1Exp,'Control','Mutant',ax1);
title('Length of pyramidal cell layer')
ylabel('Length (mm)')
ax2 = subplot(1,2,2);
dotPlot(areaHilRadCtl+areaHilOrCtl+areaCA3radCtl+areaCA3orCtl+areaCA1radCtl+areaCA1orCtl,areaHilRadExp+areaHilOrExp+areaCA3radExp+areaCA3orExp+areaCA1radExp+areaCA1orExp,'Control','Mutant',ax2);
title('Area of hippocampus')
ylabel('Area (mm2)')





function [meanCtl,stdCtl,meanExp,stdExp,h,p] = paramStats(ctlVect,expVect,debug)
% perform t-test on input control and experimental groups, and return mean
% and standard deviation of groups.  if debug is set, print a statement
% describing what was found

if nargin==2,
    debug=0;
end

meanCtl = mean(ctlVect);
stdCtl = std(ctlVect);
meanExp = mean(expVect);
stdExp = std(expVect);
[h,p] = ttest2(ctlVect,expVect);

if debug,
    disp(['     Ctl: ' num2str(meanCtl) ' ± ' num2str(stdCtl)])
    disp(['     Exp: ' num2str(meanExp) ' ± ' num2str(stdExp)])
    disp(['     p=' num2str(p) '; h=' num2str(h)])
end







