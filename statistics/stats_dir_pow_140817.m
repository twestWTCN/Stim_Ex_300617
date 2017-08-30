function stats_dir_pow_140817(R)

%% Coherence Statistics- Integrated coherence, peak magnitude,
bbounds = R.bbounds;
for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        hemin = {'L','R'};
        for side = 1:2
            load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            if R.clearer.statpow == 1
                FTdata.dirstats.pow = [];
            end
            %% STN
            expression = '\w+_CONTRA_\w+';
            cin = regexp(FTdata.freqPow.label,expression);
            inds = find(~cellfun(@isempty,cin));
            for i = 1:length(inds)
               fxA = FTdata.freqPow.freq; % Frequency X vector
                res = fxA(2) - fxA(1);  % Freq resolution
                set1 = inds(i);
                fy = squeeze(FTdata.spectanaly.spectra{1}(set1,:)); % Combined Coherence spectra
                fy_norm(i,:) = fy./abs(res*trapz(fy(round((5-R.FOI(1))/res)+1:round((40-R.FOI(1))/res)+1)));
                
                for band = 1:size(bbounds,1)
                    intCoh(band,i) = abs(res*trapz(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1)));
                    [peakMag(band,i) frq] = max(fy(round((bbounds(band,1)-R.FOI(1))/res)+1:round((bbounds(band,2)-R.FOI(1))/res)+1));
                    peakFrq(band,i) =  ((frq-1)*res)+bbounds(band,1);
                end
            end
            FTdata.freqPow.fy_norm = fy_norm;
            FTdata.freqPow.meanspectra = mean(fy_norm,1);
            FTdata.dirstats.pow.STN.intCoh = intCoh;    % Integrated Coherence
            FTdata.dirstats.pow.STN.peakMag = peakMag;  % peak magnitude within band
            FTdata.dirstats.pow.STN.peakFrq = peakFrq;  % peak frequency (Hz)
            FTdata.dirstats.pow.STN.labels = {FTdata.freqPow.label{inds}};
            save([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            clear intCoh peakMag peakFrq
        end
    end
end
