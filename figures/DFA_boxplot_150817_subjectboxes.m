function DFA_boxplot_150817_subjectboxes(R)
close all

xInds = 1:10:(10*length(R.subnames));
cmap = linspecer(3);
load([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'],'a')
for stfq = 1:length(R.stimfreq)
    rows = a.cond==R.stimfreq(stfq);
    vars = {'subject','DFA','PEB','Tot_off','trem_off','tot_on','trem_on'};
    T3 = a(rows,vars);
    T3 = T3(:,{'subject','DFA','PEB'});
    
    
    for i = 1:length(unique(a.subject)')
        dvec = table2array(T3(T3.subject==i,'DFA'));
        figure(1)
        try
            T = bplot(dvec,xInds(i) + ((stfq-1)*2),'width',1,'linewidth',1.1,'color',cmap(stfq,:));
        end
        hold on
        tickmark{i} = R.subnames{i}(end-2:end);
        
    end
    
    for i = 1:length(unique(a.subject)')
        dvec = table2array(T3(T3.subject==i,'PEB'));
        figure(2)
        try
            T = bplot(dvec,xInds(i) + ((stfq-1)*2),'width',1,'linewidth',1.1,'color',cmap(stfq,:));
        end
        hold on
        
    end
    figure(1)
    lgp1(stfq) = plot(NaN,NaN,'linewidth',2,'color',cmap(stfq,:));
    figure(2)
    lgp2(stfq) = plot(NaN,NaN,'linewidth',2,'color',cmap(stfq,:));
    
end

figure(1)
set(gcf,'color','w'); grid on;
gplota = gca;
gplota.XTick = xInds;
gplota.XTickLabels = tickmark;
gplota.FontSize = 12;
gplota.YLabel.String =  'Corrected DFA';
gplota.YLabel.FontWeight = 'bold';
gplota.YLabel.FontSize = 16;

gplota.XLabel.String =  'Subject';
gplota.XLabel.FontWeight = 'bold';
gplota.XLabel.FontSize = 16;
legend(lgp1,R.stimfrqname,'Location','NorthWest')

figure(2)
set(gcf,'color','w'); grid on;
gplota = gca;
gplota.XTick = xInds;
gplota.XTickLabels = tickmark;
gplota.FontSize = 12;
gplota.YLabel.String =  'PEB Score';
gplota.YLabel.FontWeight = 'bold';
gplota.YLabel.FontSize = 16;

gplota.XLabel.String =  'Subject';
gplota.XLabel.FontWeight = 'bold';
gplota.XLabel.FontSize = 16;

legend(lgp2,R.stimfrqname,'Location','NorthWest')

