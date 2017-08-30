clear; close all
R = buildheader_stimex;
load([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'],'a')
for stfq = 1:length(R.stimfreq)
rows = a.cond==R.stimfreq(stfq);
vars = {'subject','DFA','PEB','Tot_off','trem_off','tot_on','trem_on'};
T3 = a(rows,vars);
Tab = T3(:,{'subject','DFA','PEB'});
statarray = grpstats(Tab,'subject');
figure(1)
DFA{stfq} = table2array(statarray(:,'mean_DFA'));
T = bplot(DFA{stfq},stfq);
hold on

figure(2)
PEB{stfq} = table2array(statarray(:,'mean_PEB'));
T = bplot(PEB{stfq},stfq);
hold on
end

