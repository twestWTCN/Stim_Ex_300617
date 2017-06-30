function stats_dir_pow_040816(R)

%% Coherence Statistics- Integrated coherence, peak magnitude,
bbounds = R.bbounds;
for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'])
        if R.clearer.statpow == 1
            FTdata.dirstats.pow = [];
        end
        
        for srcloc = 1:length(R.sourcenames)
            clear fy
            inds = find(strncmp([R.sourcenames{srcloc} '_'], FTdata.freqPow.label,4)); % Source index
            intCoh = []; peakMag = []; peakFrq = [];
            for i = 1:length(inds)
                set1 = inds(i);
                fy = squeeze(FTdata.spectanaly.spectra{1}(set1,:)); % Combined Coherence spectra
                fxA = FTdata.freqPow.freq; % Frequency X vector
                res = fxA(2) - fxA(1);  % Freq resolution
                for band = 1:size(bbounds,1)
                    intCoh(band,i) = abs(res*trapz(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1)));
                    [peakMag(band,i) frq] = max(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1));
                    peakFrq(band,i) =  ((frq-1)*res)+bbounds(band,1);
                end
            end
            FTdata.dirstats.pow.(R.sourcenames{srcloc}).intCoh = intCoh;    % Integrated Coherence
            FTdata.dirstats.pow.(R.sourcenames{srcloc}).peakMag = peakMag;  % peak magnitude within band
            FTdata.dirstats.pow.(R.sourcenames{srcloc}).peakFrq = peakFrq;  % peak frequency (Hz)
            FTdata.dirstats.pow.(R.sourcenames{srcloc}).labels = {FTdata.freqPow.label{inds}};
            clear intCoh peakMag peakFrq
        end
        
        %% STN
        inds = find(strncmp('STN_', FTdata.freqPow.label,4)); % Source index
        
        for i = 1:length(inds)
            set1 = inds(i);
            fy = squeeze(FTdata.spectanaly.spectra{1}(set1,:)); % Combined Coherence spectra
            fxA = FTdata.freqPow.freq; % Frequency X vector
            res = fxA(2) - fxA(1);  % Freq resolution
            for band = 1:size(bbounds,1)
                intCoh(band,i) = abs(res*trapz(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1)));
                [peakMag(band,i) frq] = max(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1));
                peakFrq(band,i) =  ((frq-1)*res)+bbounds(band,1);
            end
        end
        FTdata.dirstats.pow.STN.intCoh = intCoh;    % Integrated Coherence
        FTdata.dirstats.pow.STN.peakMag = peakMag;  % peak magnitude within band
        FTdata.dirstats.pow.STN.peakFrq = peakFrq;  % peak frequency (Hz)
        FTdata.dirstats.pow.STN.labels = {FTdata.freqPow.label{inds}};
        save([R.analysispath R.pipestamp '\data\' R.subnames{sub} '_' R.condnames{cond} '_' R.pipestamp '.mat'],'FTdata')
        clear intCoh peakMag peakFrq
    end
end