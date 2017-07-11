function dataviewer_stimex_110717(R)
close all

for sub  = 1:length(R.subnames)
    for cond = 1:2
        hemin = {'L','R'};
        for side = 1:2
            
            for scale = 1:2
                set(0,'DefaultAxesFontSize',16)
                set(0,'defaultlinelinewidth',1.5)
                set(0,'DefaultLineMarkerSize',5)
                set(0, 'DefaultFigurePosition', [296         318        1494         678]);
                cmap = linspecer(2,'qualitative');
                
                % Waterfall Plot raw data
                figure
                %         subplot(1,2,cond)
                load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(cond)) 'Hz.mat'])
                raw = FTdata.raw;
                processed = FTdata.cleancont;
                stinds = find(strncmpi(FTdata.cleancont.label,[hemin{side} '_LFP_C'],7));
                for i = 1:length(stinds)
                    ofset = 8*(i-1);
                    rawt = raw.trial{1}(stinds(i),:) - mean(raw.trial{1}(stinds(i),:),2);
                    [p,s,mu] = polyfit(raw.time{1},rawt,32);
                    f_y = polyval(p,raw.time{1},[],mu);
                    rawt = rawt - f_y;
                    rawt = (rawt-mean(rawt))./std(rawt);
                    plot(raw.time{1},rawt+ofset,'color',cmap(1,:))
                    hold on
                    proct = processed.trial{1}(stinds(i),:);
                    proct = (proct-mean(proct))./std(proct);
                    plot(processed.time{1},proct+ofset,'color',cmap(2,:))
                end
                xlabel('Time (s)'); ylabel('Amplitude uV'); ylim([-8 35])
                if scale == 2
                    xlim([median(raw.time{1}) median(raw.time{1})+5])
                end
                title(['Stim Patient ' FTdata.details.sub ' ' R.condnames{cond} ' ' hemin{side} ' side']);
                h = legend({'raw','preprocessed'});
                set(h,'Position',[0.0118    0.0204    0.1272    0.1212])
                set(gca,'Position',[0.1834    0.0625    0.7855    0.8778])
                set(gca,'YTick',[0:8:(length(stinds)-1)*8])
                set(gca,'YTickLabel',raw.label(stinds))
                set(gcf,'Position',[229         151        1654         845])
                % Save Figures
                if scale == 2
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\preprocessing\' FTdata.details.sub '_' R.condnames{cond} '_' hemin{side} '_short'],'-jpg',1,'-r200'); close all
                else
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\preprocessing\' FTdata.details.sub '_' R.condnames{cond} '_' hemin{side} '_long'],'-jpg',1,'-r200'); close all
                end
                
                if scale == 1
                    %% Plot Spectra
                    set(0,'DefaultAxesFontSize',14)
                    set(0,'defaultlinelinewidth',2)
                    set(0,'DefaultLineMarkerSize',9)
                    set(0, 'DefaultFigurePosition', [669         189        1131         705]);
                    cmap = linspecer(size(raw.trial{1},1),'qualitative');
                    figure
                    stinds = find(strncmpi(FTdata.cleancont.label,[hemin{side} '_LFP_C'],7));
                    for i = 1:length(stinds)
                        cleant = processed.trial{1}(stinds(i),:);
                        [Pxx F] = pwelch(cleant,hanning(processed.fsample*2),[],processed.fsample*2,processed.fsample);
                        fxA = F;
                        fyA = Pxx./std(Pxx(F>4 & F<60));
%                         fyA = fyA-mean(Pxx(F>4 & F<60));
%                         fyA = Pxx; %(Pxx-mean(Pxx))./std(Pxx);
                        plot(fxA,fyA,'color',cmap(i,:)); hold on
                    end
                    %
                    xlim([0 100]); ylim([0 14]) 
                    xlabel('Frequency (Hz)'); ylabel('Normalised Magnitude')
                    title(['Patient ' FTdata.details.sub ' ' R.condnames{cond} ' ' hemin{side} ' side Spectral Estimate'])
                    legend(raw.label{stinds})
                    set(gcf,'Position',[838   307   962   587])
                    l = axes;
                    for i = 1:length(stinds)
                        cleant = processed.trial{1}(stinds(i),:);
                        [Pxx F] = pwelch(cleant,hanning(processed.fsample*2),[],processed.fsample*2,processed.fsample);
                        fxA = F;
                        fyA = Pxx./std(Pxx(F>4 & F<60));
%                         fyA = fyA-mean(Pxx(F>4 & F<60)); %Pxx; %(Pxx-mean(Pxx))./std(Pxx);
                        plot(fxA,fyA,'color',cmap(i,:)); hold on
                    end
                    xlim([5 30])
                    set(l,'Position',[0.4382    0.4835    0.2271    0.4092])
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\preprocessing\' FTdata.details.sub '_' R.condnames{cond} '_' hemin{side} '_spectra'],'-jpg',1,'-r200'); close all
                    
                end % spectra if on scale 1
            end % loop scales
        end % loop hemis
    end % loop conds
end % loops subs
