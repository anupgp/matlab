function out = centeraxes_mod(ax,opt)
% out = centeraxes(ax,opt)
%==========================================================================
% Center the coordinate axes of a plot so that they pass through the 
% origin.
%
% Input: 0, 1 or 2 arguments
%        0: Moves the coordinate axes of 'gca', i.e. the currently active 
%           axes.
%        1: ax, a handle to the axes which should be moved.
%        2: ax, opt, where opt is a struct with further options
%                opt.fontsize = 'size of axis tick labels'
%                opt.fontname = name of axis tick font.
%
% If the opt struct is ommitted, the current values for the axes are used.
%
% Output: stuct out containing handles to all line objects created by this
%         function.
%
%==========================================================================
% Version: 1.1
% Created: October 1, 2008, by Johan E. Carlson
% Last modified: November 21, 2009, by Johan E. Carlson
%==========================================================================

if nargin < 2,
    fontsize = get(ax,'FontSize');
    fontname = get(ax,'FontName');
end
if nargin < 1,
    ax = gca;
end

if nargin == 2,
    if isfield(opt,'fontsize'),
        fontsize = opt.fontsize;
    else
        fontsize = get(ax,'FontSize');
    end;
    if isfield(opt,'fontname'),
        fontname = opt.fontname;
    else
        fontname = get(ax,'FontName');
    end
end

axes(ax);
set(gcf,'color',[1 1 1]);
xtext = get(get(ax,'xlabel'),'string');
ytext = get(get(ax,'ylabel'),'string');

%--------------------------------------------------------------------------
% Check if the current coordinate system include the origin. If not, change
% it so that it does!
%--------------------------------------------------------------------------
% xlim = 1.1*get(ax,'xlim');
% ylim = 1.1*get(ax,'ylim');
% set(ax,'xlim',xlim);
% set(ax,'ylim',ylim);
% 
% if xlim(1)>0,
%     xlim(1) = 0;
% end
% 
% if ylim(1)>0,
%     ylim(1) = 0;
% end
% 
% if xlim(2) < 0,
%     xlim(2) = 0;
% end
% 
% if ylim(2) < 0,
%     ylim(2) = 0;
% end;
% 
% set(ax,'xlim',xlim,'ylim',ylim);




% -------------------------------------------------------------------------
% Store old tick values and tick labels
% -------------------------------------------------------------------------
ytick = get(ax,'YTick');
xtick = get(ax,'XTick');
%xticklab = get(ax,'XTickLabel');

%yticklab = get(ax,'YTickLabel');
ylimits = get(ax,'YLim');
xlimits = get(ax,'XLim');
%xticklab = num2str(xlimits(1):mean(diff(str2num(get(gca,'XTickLabel')))):xlimits(2));
xticklab = num2str(xtick);
yticklab = num2str(ytick);
width = get(ax,'LineWidth');
%ticklength =  get(ax,'TickLength');

%xticklength = 0.0008*(abs(diff(xlimits)));
%yticklength = (abs(diff(xlimits)))*0.01;%0.2*(abs(diff(ylimits)));

% -------------------------------------------------------------------------
% Caculate size of the "axis tick marks"
% -------------------------------------------------------------------------
 axpos = get(ax,'position');
 figpos = get(gcf,'position');
 aspectratio = axpos(4) / (axpos(3));
 xsize = xlimits(2) - xlimits(1);
 ysize = ylimits(2) - ylimits(1);
 xticklength = ysize/figpos(4)*12;
 yticklength = xsize*aspectratio/figpos(3)*12;

% -------------------------------------------------------------------------
% Draw new Y axis
% -------------------------------------------------------------------------

yax = line([0,0],[ylimits(1),ylimits(2)],'LineWidth',width);
set(yax,'color',[0 0 0])
xax = line([xtick(1),xtick(end)],[0, 0],'LineWidth',width);
set(xax,'color',[0 0 0])
set(ax,'Visible','off');
set(ax,'box','off');
% Draw x-axis ticks
r = xticklab;
for k = 1:length(xtick)
    [c,r] = strtok(r);
    newxtick(k) = line([xtick(k),xtick(k)],[-xticklength, xticklength],'Color',[0,0,0]);   
     if (xtick(k)~=0)               
         newxticklab(k) = text(xtick(k),-2*xticklength, strtrim(c));
         set(newxticklab(k),'HorizontalAlignment','center',...
             'Fontsize',fontsize,'FontName',fontname);
     end
end
r = yticklab;
% Draw y-axis ticks
for k = 1:length(ytick)
    [c,r] = strtok(r);
    newytick(k) = line([-yticklength; yticklength],[ytick(k); ytick(k)],'Color',[0,0,0]);   
     if (ytick(k)~=0)
         newyticklab(k) = text(-2*yticklength,ytick(k), strtrim(c));
         set(newyticklab(k),'VerticalAlignment','middle',...
             'HorizontalAlignment','center',...
             'FontSize',fontsize,'FontName',fontname);
     end
end

%--------------------------------------------------------------------------
% Move xlabels
%--------------------------------------------------------------------------
% newxlabel = text(xlimits(2),2*xticklength,xtext);
% set(newxlabel,'HorizontalAlignment','center',...
%     'FontWeight','demi','FontSize',fontsize+2,'FontName',fontname);
% 
 newylabel = text(-yticklength,ylimits(2)*1.02,ytext);
 set(newylabel,'HorizontalAlignment','right','VerticalAlignment','top',...
     'FontWeight','demi','FontSize',fontsize+2,'FontName',fontname);

%--------------------------------------------------------------------------
% Create arrowheads
%--------------------------------------------------------------------------
% x = [0; -yticksize/4; yticksize/4];
% y = [ylim(2); ylim(2)-xticksize; ylim(2)-xticksize];
% %patch(x,y,[0 0 0])
% 
% x = [xlim(2); xlim(2)-yticksize; xlim(2)-yticksize];
% y = [0; xticksize/4; -xticksize/4];
%patch(x,y,[0 0 0])



%--------------------------------------------------------------------------
% Create output struct
%--------------------------------------------------------------------------

if nargout > 0,
    out.xaxis = xax;
    out.yaxis = yax;
    out.xtick = newxtick;
    out.ytick = newytick;
    out.xticklabel = newxticklab;
    out.yticklabel = newyticklab;
    out.newxlabel = newxlabel;
    out.newylabel = newylabel;
end;