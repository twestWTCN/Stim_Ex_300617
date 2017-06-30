function [ax clustat] = freqclusterplotlog(OFF,ON,fxA,stat,alpha,titular,ylab,ylimd,cmap,dir)
if nargin<5
    alpha = 0.05;
end
if nargin<6
    titular = 'spectral stats for unknown analysis';
end
if nargin<6
    ylab = 'scaler';
end
if nargin <10
    dir = 0;
end
if size(fxA,1)>size(fxA,2)
    fxA = fxA';
end

lineind = find(fxA>48.5 & fxA<51.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));
ON(:,lineind) = NaN(size(ON,1),size(lineind,2));

lineind = find(fxA>98.5 & fxA<101.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));
ON(:,lineind) = NaN(size(ON,1),size(lineind,2));

lineind = find(fxA>148.5 & fxA<151.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));
ON(:,lineind) = NaN(size(ON,1),size(lineind,2));

%
fxA =log10(fxA);
OFF= log10(OFF);
ON = log10(ON);

if dir == 1
    plot(repmat(fxA,size(OFF,1),1)',OFF','Color',cmap(1,:),'LineStyle','--','linewidth',1);
    hold on
    ax(2) = plot(fxA,nanmean(OFF,1),'color',cmap(1,:),'linewidth',3);
    
    plot(repmat(fxA,size(ON,1),1)',ON','Color',cmap(2,:),'LineStyle','--','linewidth',1);
    hold on
    ax(1) = plot(fxA,nanmean(ON,1),'color',cmap(1,:),'linewidth',3);
else
    plot(repmat(fxA,size(OFF,1),1)',OFF','Color',cmap(1,:),'LineStyle','--','linewidth',1);
    hold on
    ax(2) = plot(fxA,nanmean(OFF,1),'color',cmap(1,:),'linewidth',3);
    
    plot(repmat(fxA,size(ON,1),1)',ON','Color',cmap(2,:),'LineStyle','--','linewidth',1);
    hold on
    ax(1) = plot(fxA,nanmean(ON,1),'color',cmap(2,:),'linewidth',3);
end
sigfreq = stat.mask.*stat.freq;
sigfreq(sigfreq==0) = NaN;
sigpow = stat.mask.*(nanmean(nanmean(ON,1),2).*10);
if ~isempty(ylimd)
    sigpow = stat.mask.*ylimd(2)*0.85;
end
% sigpow = stat.mask.*1; %(nanmean(nanmean(ON,1),2).*7.5);

sigpow(sigpow==0) = NaN;
if sum(~isnan(sigpow))<2
    block = scatter(sigfreq,sigpow,'ks','filled');
else
    block = plot(log10(sigfreq),log10(sigpow),'k','linewidth',6);
end

xlim(log10([4 150]));
Ymax = 0.95*max(block.YData);
ylim([min([ax(1).YData ax(2).YData]) 0.9*max([ax(1).YData ax(2).YData])])
clustat = [];
if sum(stat.mask)>0
    for i = 1:size(stat.posclusters,2)
        if stat.posclusters(i).prob<alpha
            labs = stat.posclusterslabelmat;
            freqcen = mean(stat.freq(1,find(labs==i)));
            if freqcen<48 || freqcen>52
                freqcen = log10(freqcen);
                [figx figy] = dsxy2figxy(gca, freqcen-0.1, Ymax);
                h = annotation('textbox',[figx figy .01 .01],'String',{['P = ' num2str(stat.posclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',8);
                clustat = [clustat; min(stat.freq(1,find(labs==i))) max(stat.freq(1,find(labs==i))) stat.posclusters(i).prob];
            end
        end
    end
    for i = 1:size(stat.negclusters,2)
        if stat.negclusters(i).prob<alpha
            labs = stat.negclusterslabelmat;
            find(labs==i)
            freqcen = mean(stat.freq(1,find(labs==i)));
            if freqcen<48 || freqcen>52
                freqcen = log10(freqcen);
                [figx figy] = dsxy2figxy(gca,  freqcen-log10(5), Ymax);
                h = annotation('textbox',[figx figy .01 .01],'String',{['P = ' num2str(stat.negclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',8);
                clustat = [clustat; min(stat.freq(1,find(labs==i))) max(stat.freq(1,find(labs==i))) stat.negclusters(i).prob];
            end
        end
    end
end

xlabel('log10 Frequency (Hz)'); ylabel(ylab); title(titular);
if  strcmp(getenv('COMPUTERNAME'), 'SFLAP-2') == 1
    x = gca;
    for i = 1:size(x.XTick,2)
        xtlab{i} = num2str(10^(x.XTick(i)),2);
    end
        x.XTickLabel = xtlab;
end
grid on