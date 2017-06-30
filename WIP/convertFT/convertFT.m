for sub  = 1:length(R.subnames)
    for cond = 1:2
        [files, seq, root, details] = dbs_subjects(R.subnames{sub}, 1)
        [trn trdets] = stimex_trialselect(R.subnames{sub});
        for n = 1:length(trn)
            parts = strsplit(files{trn(n)}, '\');
            D = spm_eeg_load([R.datapath '\' parts{4} '\' parts{5} '\SPMstim\jaspmeeg_uespmeeg_' parts{7}]);
            chn = selectchannels(D,{'STIM','LFP_STIM','LFP_CLEAN','LFP_CONTRA_01','LFP_CONTRA_12','LFP_CONTRA_23','EMG'});
            FTdata.label = {'STIM','LFP_STIM','LFP_CLEAN','LFP_CONTRA_01','LFP_CONTRA_12','LFP_CONTRA_23','EMG'};
            FTdata.fsample = D.fsample;
            Ds = D(chn,:,:);
            B = {reshape(Ds(:,:,:),size(Ds,1),size(Ds,2)*size(Ds,3))};
            FTdata.trial = B; % cell-array containing a data matrix for each trial (1 X Ntrial), each data matrix is    Nchan X Nsamples
            FTdata.time = {linspace(0,length(B{1})/D.fsample,length(B{1}))};   % cell-array containing a time axis for each trial (1 X Ntrial), each time axis is a 1 X Nsamples vector
            
        end
    end
end