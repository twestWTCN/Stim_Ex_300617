function plot_pow_spectra_stat(R)
dirna = 'Power';
appender = 'draft';

for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        hemin = {'L','R'};
        for side = 1:2
            load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            
            Astore(:,side,stfq,sub) = FTdata.freqPow.meanspectra';
            
            
            
        end
    end
end
stim_0 = reshape(Astore(:,:,1,:),295,[]);
stim_5 = reshape(Astore(:,:,2,:),295,[]);
stim_130 = reshape(Astore(:,:,3,:),295,[]);

dattab = {stim_0 stim_5 stim_130};
cmap = linspecer(3);

[specstat_0_130] = spectralclusterstats060317(stim_0',stim_130',FTdata.freqPow.freq',R.sourcenames{3},5000);
[specstat_0_5] = spectralclusterstats060317(stim_0',stim_5',FTdata.freqPow.freq',R.sourcenames{3},5000);
[specstat_5_130] = spectralclusterstats060317(stim_5',stim_130',FTdata.freqPow.freq',R.sourcenames{3},5000);

spectab = {specstat_0_130 specstat_0_5 specstat_5_130};
for i = 1:2
    if i == 2
        subflag = 0;
    else
        subflag = 1;
    end
    figure(i); set(gcf,'color','w');
    [ax clustattab] = freqclusterplot_150817(dattab,FTdata.freqPow.freq,spectab,0.05,'Group Averages Power Spectrum','NPD',[0 0.3],cmap,0,subflag);
    legend(ax,R.condnames)
    ylabel('Normalised Power'); xlabel('Frequency (Hz)');
        if i == 2
        ylim([0.02 0.07]); xlim([5 30]);
    else
        ylim([0 0.2]); xlim([5 60]);
    end
end
saveallfiguresFIL([R.analysispath R.pipestamp '\results\figures\spectra\' dirna '\' dirna '_' R.sourcenames{3} appender '_spectra'],'-jpg',0); close all
