function plot_gen_stimex_spectra_040816(R)
close all
%% Generic plotter for bivariate connectivity measures.
spctralist = R.spectra.featspecs;

undirected = 1;
for srcloc = 1:length(R.sourcenames)
    for feat = 1:length(spctralist) % run through features
        % get ft spectra names
        if strncmp(spctralist{feat},'power',8)
            spctrname = 'spectra'; dirna = 'Power';
            undirected = 1; variate = 1;
        elseif strncmp(spctralist{feat},'coherence',8)
            spctrname = 'cohspctrm'; dirna = 'Coherence';
            undirected = 1; variate = 2;
        elseif strncmp(spctralist{feat},'wpli',8)
            spctrname = 'wpli_debiasedspctrm'; dirna = 'WPLI';
            undirected = 1; variate = 2;
        elseif strncmp(spctralist{feat},'granger',8)
            spctrname = 'grangerspctrm'; dirna = 'Granger';
            undirected = 0; variate = 2;
        end
        
        for sub  = 1:length(R.subnames)
            for cond = 1:length(R.stimfreq)
                load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(cond)) 'Hz.mat'])
                if variate == 1 % univariate (power)
                    inds = find(strncmp([R.sourcenames{srcloc} '_'], FTdata.freqPow.label,size(R.sourcenames{srcloc},2)));
                    fxA = FTdata.freqPow.freq;
                    fyA{cond,sub} = FTdata.spectanaly.spectra{1}(inds,:);
                elseif variate == 2 % bivariate (connectivity)
                    clear fy
                    inds = find(strncmp([R.sourcenames{srcloc} '_'], FTdata.freqPow.label,size(R.sourcenames{srcloc},2)));
                    for i = 1:length(inds)
                        set1 = inds(i);
                        set2 = find(strncmp(['LFP_CONTRA_'],FTdata.coherence.label,9));
                        fy(i,:) = mean(abs(squeeze(FTdata.(spctralist{feat}).(spctrname)(repmat(set1,1,size(set2,2)),set2,:))));
                        %                         if strncmp(spctralist{feat},'wpli',8)
                        %                             plot(FTdata.(spctralist{feat}).freq,fy(i,:))
                        %                             hold on
                        %                         end
                    end
                    if isempty(inds)
                        fy = [];
                    end
                    fxA = FTdata.(spctralist{feat}).freq;
                    fyA{cond,sub} = fy;
                end
            end
        end
        clear A
        for large = 0:1
            if large == 1
                FOI = [2 45];
            else
                FOI = R.FOI;
            end
            if undirected == 1 && variate == 1
                figure
                for i = 1:length(R.stimfreq)
                    A(i,:) = mean(vertcat(fyA{i,:}),1);
                end
                plot(repmat(fxA,length(R.stimfreq),[])',A')
                ylim([0 1.2*max(A(:))]);xlim(FOI)
                title([R.sourcenames{srcloc} ' Source Power Spectra'], 'Interpreter', 'none')
                legend(R.stimfrqname)
                ylabel('Normalised Power'); xlabel('Frequency (Hz)');
                if ~exist([R.analysispath R.pipestamp '\results\figures\' dirna], 'dir')
                    mkdir([R.analysispath R.pipestamp '\results\figures\' dirna]);
                end
                if large == 1
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\figures\' dirna '\' dirna '_' R.sourcenames{srcloc} '_large_spectra'],'-jpg'); close all
                else
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\figures\' dirna '\' dirna '_' R.sourcenames{srcloc} '_spectra'],'-jpg'); close all
                end
                
            elseif undirected == 1 && variate == 2
                
                figure
                for i = 1:length(R.stimfreq)
                    A(i,:) = mean(vertcat(fyA{i,:}),1);
                end
                plot(repmat(fxA,length(R.stimfreq),[])',A')
                if sum(find(isnan(A)))>1
                    ylim([0 1]);xlim(R.FOI)
                else
                    ylim([0 1.2*max(A(:))]);xlim(FOI)
                end
                title(['LFP Contra <-> ' R.sourcenames{srcloc} ' Source ' dirna ' Spectra'], 'Interpreter', 'none')
                legend(R.stimfrqname)
                ylabel(spctralist{feat}); xlabel('Frequency (Hz)')
                if ~exist([R.analysispath R.pipestamp '\results\figures\' dirna], 'dir')
                    mkdir([R.analysispath R.pipestamp '\results\figures\' dirna]);
                end
                if large
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\figures\' dirna '\' dirna '_STN_' R.sourcenames{srcloc} '_large_spectra'],'-jpg'); close all
                else
                    saveallfiguresFIL([R.analysispath R.pipestamp '\results\figures\' dirna '\' dirna '_STN_' R.sourcenames{srcloc} '_spectra'],'-jpg'); close all
                end 
            else
            end
        end
    end
end