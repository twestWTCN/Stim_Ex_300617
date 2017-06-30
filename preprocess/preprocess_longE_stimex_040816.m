function preprocess_longE_stimex_040816(R)
for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        load([R.analysispath R.pipestamp '\data\split\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'])
        D = sFTdata.trial{1};
        % Find missing fragments
        for k = 1:size(D,1)
            t = D(k,:,:);
            t2 = find(isnan(t));
            N = 1; % Required number of consecutive numbers following a first one
            x = diff(t2)==1;
            f = find([false,x]~=[x,false]);
            frags = reshape(f,2,[])';
            for j = 1:size(frags,1)
                t(t2(frags(j,1):frags(j,2))) = nanmean(t); % replace with mean.
            end
            D(k,:,:) = t;
        end
        sFTdata.trial{1} = D;
        cfg = [];
        %         cfg.resamplemethod = 'resample';
        cfg.resamplefs = R.ds;
        cfg.demean = 'yes';
        sFTdata = ft_resampledata(cfg,sFTdata);
        
        % Epoched Data
        % First epoch into segments (1s)
        cfg = [];
        cfg.length  = R.longE_length;
        FTdataX = ft_redefinetrial(cfg, sFTdata);
        cfg_red = cfg;
        
        % Preprocess
        cfg = [];
        cfg.hpfilter  = 'yes'; % highpass
        cfg.hpfreq = R.FOI-1;
        cfg.lpfilter  = 'yes';  % low pass
        cfg.lpfreq = 95;    % low pass just below nyquist
        cfg.demean = 'yes';
        cfg.dftfilter = 'yes'; % line noise filter
        FTdataX = ft_preprocessing(cfg,FTdataX);
        
        trialstokeep = 1:numel(FTdataX.trial);
        trialstokeep([1,2 numel(FTdataX.trial)-1 numel(FTdataX.trial)]) = [];
        cfg = [];
        cfg.trials = trialstokeep;
        FTdataX = ft_preprocessing(cfg, FTdataX);
        
        %% Muscle Artefact LFP
        cfg = [];
        % channel selection, cutoff and padding
        cfg.artfctdef.zvalue.channel = '*';
        cfg.artfctdef.zvalue.cutoff      = 4;
        cfg.artfctdef.zvalue.trlpadding  = 0;
        cfg.artfctdef.zvalue.fltpadding  = 0;
        cfg.artfctdef.zvalue.artpadding  = 0.1;
        
        % algorithmic parameters
        cfg.artfctdef.zvalue.bpfilter    = 'yes';
        cfg.artfctdef.zvalue.bpfreq      = [75 95];
        %         cfg.artfctdef.zvalue.bpfiltord   = 9;
        cfg.artfctdef.zvalue.bpfilttype  = 'but';
        cfg.artfctdef.zvalue.hilbert     = 'yes';
        cfg.artfctdef.zvalue.boxcar      = 0.2;
        
        [cfg, artifact_muscle] = ft_artifact_zvalue(cfg,FTdataX);
        
        %% EOG Artefact Removal
        cfg = [];
        % channel selection, cutoff and padding
        if ~isempty(find(strncmp(FTdataX.label,'VEOG',6)))
            cfg.artfctdef.zvalue.channel     = {'VEOG'    'HEOG'};
        else
            cfg.artfctdef.zvalue.channel     = '*';
        end
        cfg.artfctdef.zvalue.cutoff      = 4;
        cfg.artfctdef.zvalue.trlpadding  = 0;
        cfg.artfctdef.zvalue.artpadding  = 0.1;
        cfg.artfctdef.zvalue.fltpadding  = 0;
        
        % algorithmic parameters
        cfg.artfctdef.zvalue.bpfilter   = 'yes';
        cfg.artfctdef.zvalue.bpfilttype = 'but';
        cfg.artfctdef.zvalue.bpfreq     = [6 15];
        %         cfg.artfctdef.zvalue.bpfiltord  = 4;
        cfg.artfctdef.zvalue.hilbert    = 'yes';
        
        % feedback
        %         cfg.artfctdef.zvalue.interactive = 'yes';
        [cfg, artifact_EOG] = ft_artifact_zvalue(cfg,FTdataX);
        
        cfg=[];
        cfg.artfctdef.reject = 'partial';
        cfg.artfctdef.eog.artifact = artifact_EOG; %
        cfg.artfctdef.muscle.artifact = artifact_muscle;
        cfg.feedback='yes'
        cfg.artfctdef.minaccepttim = 5;
        FTdataX = ft_rejectartifact(cfg,FTdataX);
        
        load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'])
        FTdata.LongEpochedData = FTdataX;
        save([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
    end
end
