function convertFT_260716(R)
for sub  = 1:length(R.subnames)
    [files, seq, root, details] = dbs_subjects(R.subnames{sub}, 0);
    [trn trstim trdef details] = stimex_trialselect(R.subnames{sub});
%       [trn trdets] = stimex_trialselect(R.subnames{sub});

    for n = 1:length(trn)
        clear FTdata
        % convert from SPM to FT
        parts = strsplit(files{trn(n)}, '\');
        D = spm_eeg_load([R.datapath '\' parts{4} '\' parts{5} '\SPMstim_LFPonly\' parts{4} '_' seq{trn(n)}]);
        chn = selectchannels(D,{'STIM','LFP_STIM','LFP_CLEAN','LFP_CONTRA_01','LFP_CONTRA_12','LFP_CONTRA_23'});
        FTdata.label = {'STIM','LFP_STIM','LFP_CLEAN','LFP_CONTRA_01','LFP_CONTRA_12','LFP_CONTRA_23'};
        FTdata.fsample = D.fsample;
        Ds = D(chn,:,:);
        B = {reshape(Ds(:,:,:),size(Ds,1),size(Ds,2)*size(Ds,3))};
        FTdata.trial = B; % cell-array containing a data matrix for each trial (1 X Ntrial), each data matrix is    Nchan X Nsamples
        FTdata.time = {linspace(0,length(B{1})/D.fsample,length(B{1}))};   % cell-array containing a time axis for each trial (1 X Ntrial), each time axis is a 1 X Nsamples vector
        save([R.analysispath R.pipestamp '\data\raw\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_raw.mat'],'FTdata')
        % section up into STIM ON and OFF
%         stim = FTdata.trial{1}(strmatch('STIM', FTdata.label),:);
%         stim = stim-mean(stim);
%         disp([R.subnames{sub} ' ' seq{trn(n)}])
%         disp(seq)
%         plot(FTdata.time{1},stim); shg
%         clf
        for i = 1:2
            % Split up trials into two
            cfg = [];
            cfg.toilim = trdef{1}(n,2*i-1:2*i);
            sFTdata = ft_redefinetrial(cfg, FTdata);
            sFTdata.stimfreq = trstim{n}(i);
            sFTdata.stimside = seq{trn(n)}(6);
            sFTdata.details = details;
            % Downsample
            cfg = [];
            cfg.resamplefs = R.ds;
            cfg.detrend  = 'yes';
            sFTdata = ft_resampledata(cfg, sFTdata);
            save([R.analysispath R.pipestamp '\data\split\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' sFTdata.stimside '_stim' num2str(sFTdata.stimfreq) 'Hz.mat'],'sFTdata')
        end
    end
end
