function spectalanalysis_stimex_040816(R)
for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'])
        % Power
        cfg            = [];
        cfg.output     = 'powandcsd';
        cfg.method     = 'mtmfft';
        cfg.foilim     = R.FOI;
        cfg.taper = 'hanning';
%         cfg.tapsmofrq  = 1.5;
%         cfg.pad = 'nextpow2';
        cfg.keeptrials = 'no';
        freqPow    = ft_freqanalysis(cfg,FTdata.EpochedData);
        FTdata.freqPow = freqPow;
        cfg_freq = cfg;
%         if R.spectanaly.cplot(1) == 1
%             figure
%             subplot(2,2,1)
%             inds = find(strncmp([R.bandnames{1} '_'], freqPow.label,4)); % Source index
%             plot(repmat(freqPow.freq,6,1)',freqPow.powspctrm(inds,:)');
%             title(R.bandnames{1})
%             subplot(2,2,2)
%             inds = find(strncmp([R.bandnames{2} '_'], freqPow.label,4)); % Source index
%             plot(repmat(freqPow.freq,4,1)',freqPow.powspctrm(inds,:)');
%             title(R.bandnames{2})
%             subplot(2,2,3)
%             inds = find(strncmp([R.bandnames{4} '_'], freqPow.label,4)); % Source index
%             plot(repmat(freqPow.freq,4,1)',freqPow.powspctrm(inds,:)');
%             title(R.bandnames{3})
%             subplot(2,2,4)
%             inds = find(strncmp([R.bandnames{5} '_'], freqPow.label,4)); % Source index
%             plot(repmat(freqPow.freq,4,1)',freqPow.powspctrm(inds,:)');
%             title(R.bandnames{4})
%         end
        
        % Fourier
        cfg = [];
        cfg.method     = 'mtmfft';
        cfg.taper = 'hanning';
        cfg.keeptrials = 'no';
        cfg.output     = 'fourier';
        cfg.keeptrials = 'yes';
        freqFour    = ft_freqanalysis(cfg,FTdata.EpochedData);
        FTdata.freqFour = freqFour;
        
        % store to variables
        ft = freqPow.freq; fxx = freqPow.powspctrm;
        res= ft(2)-ft(1); % Frequency resolution
        
        % Compute confidence intervals
        CI = repmat(0.8512*sqrt(1/length(FTdata.EpochedData.trial)),size(fxx));    % Analytic (DH)
        
        %Correct powerline and normalise by full power
        for i = 1:size(fxx,1)
            fxxi = fxx(i,:);
            %             fxxi(round((48-LN)/res+1):round((52-LN)/res+1)) = mean(fxxi(round((46-LN)/res+1):round((48-LN)/res+1)));    % Correct powerline to mean power in prior 6 Hz
            fxxi = fxxi/(res*trapz(fxxi(round((4-R.FOI(1))/res)+1:round((48-R.FOI(1))/res)+1)));  % Normalise by power between 4 and 48
            fxx(i,:) = fxxi;
            
            CIi = CI(i,:);  % Form confidence interval
            CIi = CIi/(res*trapz(CIi)); % normalise
            CI(i,:) = CIi;
        end

        FTdata.spectanaly.spectra = {fxx};
                
        if R.spectanaly.cplot(1) == 1
            figure
            subplot(2,2,1)
            inds = find(strncmp(['STIM'], freqPow.label,4)); % Source index
            plot(repmat(freqPow.freq,length(inds),1)',FTdata.spectanaly.spectra{1}(inds,:)');
            title('STIM')
            subplot(2,2,2)
            inds = find(strncmp(['LFP_STIM'], freqPow.label,8)); % Source index
            plot(repmat(freqPow.freq,length(inds),1)',FTdata.spectanaly.spectra{1}(inds,:)');
            title('LFP_STIM')
            subplot(2,2,3)
            inds = find(strncmp(['LFP_CLEAN'], freqPow.label,8)); % Source index
            plot(repmat(freqPow.freq,length(inds),1)',FTdata.spectanaly.spectra{1}(inds,:)');
            title('LFP_CLEAN')
            subplot(2,2,4)
            inds = find(strncmp(['LFP_CONTRA_01'], freqPow.label,8)); % Source index
            plot(repmat(freqPow.freq,length(inds),1)',FTdata.spectanaly.spectra{1}(inds,:)');
            title('LFP_CONTRA_01')
        end
        
        % Compute Coherence
        cfg = [];
        cfg.method = 'coh';
        cfg.foilim     = R.FOI;
        coherence = ft_connectivityanalysis(cfg, freqFour);  % Compute coherence
        if R.spectanaly.cplot(2) == 1
            cfg = [];
            cfg.parameter = 'cohspctrm';
            figure;ft_connectivityplot(cfg, coherence);
        end
        FTdata.coherence = coherence;
        
        % Compute WPLI
        cfg = [];
        cfg.method = 'wpli_debiased';
        cfg.foilim     = R.FOI;
        wpli = ft_connectivityanalysis(cfg, freqFour);
        if R.spectanaly.cplot(2) == 1
            cfg = [];
            cfg.parameter = 'wpli_debiasedspctrm';
            figure;ft_connectivityplot(cfg, wpli);
        end
        FTdata.wpli = wpli;
        
        save([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
    end
end