function DFA_boxplot_150817_groupmean(R)
load([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'],'a')
for stfq = 1:length(R.stimfreq)
rows = a.cond==R.stimfreq(stfq);
vars = {'subject','DFA','PEB','Tot_off','trem_off','tot_on','trem_on'};
T3 = a(rows,vars);
T3 = T3(:,{'subject','DFA','PEB'});


for i = 1:length(R.subnames)
    
    
    
figure(1)
end
end

