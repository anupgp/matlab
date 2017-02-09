%%

%[cc,si] = abfload('~/DATA/AHP_HC/Data/OCT312011_C3_CC.abf','channels',{'10 Vm'},'sweeps',1:20);
%[cc,si] = abfload('~/DATA/AHP_HC/Data/SEP072011_C5_CV.abf','channels',{'10 Vm'},'sweeps',1:20);
%[cc,si] = abfload('~/DATA/AHP_OFC/data/AUG302011/C2/AUG302011AHP_C2_CV.abf','channels',{'10 Vm'},'sweeps',1:20);
[cc,si] = abfload('~/DATA/AHP_OFC/data/20120803/C7/AUG032012AHP_C7_CC.abf','channels',{'Vm'},'sweeps',1:20);
cc=reshape(cc,500000,20);
t=0:20E-06:499999*20E-06;
%[tf, ccf] = gaussfilt2d(t,cc,100,100/6);
[tf, ccf] = gaussfilt2d(t,cc,50,50/6);
ccnf = bsxfun(@minus,ccf,mean(ccf(tf<0.16,:),1))/10 -70;

%%
figure(1);                                     % select figure pane
set(gcf, 'PaperUnits', 'inches');              % units
width=3.5;                                     % width of figure
height=width*0.75;                             % 75% width keeps default ratio
set(gcf, 'PaperPositionMode', 'manual');       % turn off 'auto' so it doesn't resize upon printing
papersize = get(gcf, 'PaperSize');             % for US paper, 8.5 x 11
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
set(gcf, 'PaperPosition', [left bottom width height]);  % middle of page
%set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
set(gca,'LooseInset',get(gca,'TightInset'));    % this works better

set(gca,'xcolor',[1 1 1])
set(gca,'XTick',[]);
set(gca,'ycolor',[1 1 1])
set(gca,'YTick',[]);
set(gca,'box','off')
set(get(gca,'xlabel'),'Color',[1 1 1]);
set(gca,'Visible','off')

colorOrder = flipud(gray(15));
set(gca,'ColorOrder',colorOrder(end-10:end,:));
set(gca,'NextPlot','replacechildren')

%%
plot(tf,ccnf(:,[4]),'LineWidth',1);
%plot(tf,ccnf(:,2:2:20),'LineWidth',1);
line([0.12,2],[-70,-70],'color','black','LineStyle','--')
axis([0.12,2,-82,30]);
line([1.6,1.8],[-60,-60],'color','black','LineWidth',1)
line([1.6, 1.6],[-50,-60],'color','black','LineWidth',1)
text(1.56,-60.5,'10 mV','Rotation',90,'FontName','Arial','FontSize',12,'VerticalAlignment','bottom');
text(1.7,-64,'200 ms','Rotation',0,'FontName','Arial','FontSize',12,'HorizontalAlignment','center');
%%
plot(tf,ccnf(:,[4]),'LineWidth',1);
%line([0.12,2],[-70,-70],'color','black','LineStyle','--')
axis([0.836,0.8415,-65,40]);
line([0.8405,0.841],[-30,-30],'color','black','LineWidth',1)
line([0.841,0.841],[-30,-20],'color','black','LineWidth',1)
text(0.84135,-30,'10 mV','Rotation',90,'FontName','Arial','FontSize',12,'VerticalAlignment','bottom');
text(0.8408,-34,'0.5 ms','Rotation',0,'FontName','Arial','FontSize',12,'HorizontalAlignment','center');

%%

print(gcf,'-depsc',['-r','400'],'~/DATA/AHP_OFC/repFigAhpLO-CORT_zoom2');