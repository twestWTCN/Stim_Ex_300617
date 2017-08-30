function [ax clustat] = freqclusterplot_150817(datatab,fxA,stattab,alpha,titular,ylab,ylimd,cmap,dir,subflag)
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
if ~exist('subflag')
    subflag = 1;
end

lineind = find(fxA>48.5 & fxA<51.5);
for ii = 1:size(datatab,2)
    ydata = datatab{ii}';
    ydata(:,lineind) = NaN(size(ydata,1),size(lineind,2));
    
    if dir == 1
        if subflag == 1
        plot(repmat(fxA,size(ydata,1),1)',ydata','Color',cmap(ii,:),'LineStyle','--','linewidth',1);
        end
        hold on
        ax(ii) = plot(fxA,nanmean(ydata,1),'color',cmap(ii,:),'linewidth',4);
    else
        if subflag == 1
        plot(repmat(fxA,size(ydata,1),1)',ydata','Color',cmap(ii,:),'LineStyle','--','linewidth',1);
        end
        hold on
        ax(ii) = plot(fxA,nanmean(ydata,1),'color',cmap(ii,:),'linewidth',4);
    end
    
    stat = stattab{ii};
    sigfreq = stat.mask.*stat.freq;
    sigfreq(sigfreq==0) = NaN;
    sigpow = stat.mask.*(nanmean(nanmean(ydata,1),2).*5.1);
    if ~isempty(ylimd)
        sigpow = stat.mask.*ylimd(2)*0.93;
    end
    % sigpow = stat.mask.*1; %(nanmean(nanmean(ON,1),2).*7.5);
    
    sigpow(sigpow==0) = NaN;
    sigpow = sigpow + (ii-1)*0.05;
    if ~isempty(ylimd)
        ylim(ylimd);
    end
    xlim([4 75]);
    clustat = [];
    if sum(stat.mask)>0
        for i = 1:size(stat.posclusters,2)
            if stat.posclusters(i).prob<alpha
                labs = stat.posclusterslabelmat;
                group = find(labs==i);
                if length(group)<2
                    scatter(sigfreq(group),sigpow(group),'ks','filled');
                else
                    plot(sigfreq(group),sigpow(group),'k','linewidth',6);
                end
                freqcen = sigfreq(fix(mean(group)));
                if min(sigfreq(group))<6
                    shift = 3;
                else
                    shift = 5;
                end
                [figx figy] = dsxy2figxy(gca, freqcen-shift, (max(sigpow)*1.055));
                h = annotation('textbox',[figx figy .01 .01],'String',{['P = ' num2str(stat.posclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',10,'fontweight','bold');
                clustat = [clustat; min(stat.freq(1,group)) max(stat.freq(1,group)) stat.posclusters(i).clusterstat stat.posclusters(i).prob];
            end
        end
        for i = 1:size(stat.negclusters,2)
            if stat.negclusters(i).prob<alpha
                labs = stat.negclusterslabelmat;
                group = find(labs==i);
                if length(group)<2
                    scatter(sigfreq(group),sigpow(group),'ks','filled');
                else
                    plot(sigfreq(group),sigpow(group),'k','linewidth',6);
                end
                freqcen = sigfreq(fix(mean(group)));
                if min(sigfreq(group))<6
                    shift = 3;
                else
                    shift = 5;
                end
                [figx figy] = dsxy2figxy(gca, freqcen-shift, (max(sigpow)*1.055));
                h = annotation('textbox',[figx figy .01 .01],'String',{['P = ' num2str(stat.negclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',10,'fontweight','bold');
                clustat = [clustat; min(stat.freq(1,group)) max(stat.freq(1,group)) stat.negclusters(i).clusterstat stat.negclusters(i).prob];
            end
        end
    end
end
% a = get(gca,'XTickLabel');
% b = get(gca,'YTickLabel');
xlabel('Frequency (Hz)','fontsize',16); ylabel(ylab,'fontsize',16);% title(titular);


% set(gca,'XTickLabel',a,'fontsize',18)
% set(gca,'YTickLabel',b,'fontsize',18)
grid on