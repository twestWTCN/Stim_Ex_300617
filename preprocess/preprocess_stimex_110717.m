function preprocess_stimex_110717(R)
if R.clear.pp == 1
    delete([R.analysispath R.pipestamp '\data\processed\*.mat'])
end
hpfilt = designfilt('highpassfir','StopbandFrequency',1, ...
    'PassbandFrequency',4,'PassbandRipple',0.05, ...
    'StopbandAttenuation',50,'DesignMethod','kaiserwin','SampleRate',R.ds);

for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        hemin = {'L','R'};
        for side = 1:2
            datapath = [R.analysispath R.pipestamp '\data\split\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'];
            if exist(datapath,'file')
                load(datapath)
                for i = 1:length(sFTdata.label)
                    newlabel{i} = [hemin{side} '_' sFTdata.label{i}];
                end
                sFTdata.label = newlabel;
            end
            % Merge left and right stims
            
            % Epoched Data
            % First epoch into segments (1s)
            cfg = [];
            cfg.length  = 1.5;
            FTdataX = ft_redefinetrial(cfg, sFTdata);
            
            % Preprocess
            cfg = [];
            cfg.hpfilter  = 'yes'; % highpass
            cfg.hpfreq = R.FOI(1);
            cfg.lpfilter  = 'yes';  % low pass
            cfg.demean = 'yes';
            cfg.lpfreq = R.FOI(2);
            cfg.lpfilttype = 'fir';
            cfg.hpfilttype = 'fir';
            cfg.dftfilter = 'no'; % line noise filter
            FTdataX = ft_preprocessing(cfg,FTdataX);
            
%             trialstokeep = 1:numel(FTdataX.trial);
%             trialstokeep([1,2 numel(FTdataX.trial)-1 numel(FTdataX.trial)]) = [];
%             cfg = [];
%             cfg.trials = trialstokeep;
%             FTdataX = ft_preprocessing(cfg, FTdataX);
            
            %         %% Muscle Artefact LFP
            %         cfg = [];
            %         % channel selection, cutoff and padding
            %         cfg.artfctdef.zvalue.channel = '*';
            %         cfg.artfctdef.zvalue.cutoff      = 4;
            %         cfg.artfctdef.zvalue.trlpadding  = 0;
            %         cfg.artfctdef.zvalue.fltpadding  = 0;
            %         cfg.artfctdef.zvalue.artpadding  = 0.1;
            %
            %         % algorithmic parameters
            %         cfg.artfctdef.zvalue.bpfilter    = 'yes';
            %         cfg.artfctdef.zvalue.bpfreq      = [75 95];
            %         %         cfg.artfctdef.zvalue.bpfiltord   = 25;
            %         cfg.artfctdef.zvalue.bpfilttype  = 'but';
            %         cfg.artfctdef.zvalue.hilbert     = 'yes';
            %         cfg.artfctdef.zvalue.boxcar      = 0.2;
            %
            %         [cfg, artifact_muscle] = ft_artifact_zvalue(cfg,FTdataX);
            %         %% EOG Artefact Removal
            %         cfg = [];
            %         % channel selection, cutoff and padding
            %         if ~isempty(find(strncmp(sFTdata.label,'VEOG',6)))
            %             cfg.artfctdef.zvalue.channel     = {'VEOG'    'HEOG'};
            %         else
            %             cfg.artfctdef.zvalue.channel     = '*';
            %         end
            %         cfg.artfctdef.zvalue.cutoff      = 5;
            %         cfg.artfctdef.zvalue.trlpadding  = 0;
            %         cfg.artfctdef.zvalue.artpadding  = 0.1;
            %         cfg.artfctdef.zvalue.fltpadding  = 0;
            %
            %         % algorithmic parameters
            %         cfg.artfctdef.zvalue.bpfilter   = 'yes';
            %         cfg.artfctdef.zvalue.bpfilttype = 'but';
            %         cfg.artfctdef.zvalue.bpfreq     = [6 15];
            %         %         cfg.artfctdef.zvalue.bpfiltord  = 4;
            %         cfg.artfctdef.zvalue.hilbert    = 'yes';
            %
            %         % feedback
            %         %                           cfg.artfctdef.zvalue.interactive = 'yes';
            %         [cfg, artifact_EOG] = ft_artifact_zvalue(cfg,FTdataX);
            %
            %         cfg=[];
            %         cfg.artfctdef.reject = 'complete';
            %         cfg.artfctdef.eog.artifact = artifact_EOG; %
            %         cfg.artfctdef.muscle.artifact = artifact_muscle;
            %         cfg.feedback='yes';
            %         FTdataX = ft_rejectartifact(cfg,FTdataX);
            
            FTdata.EpochedData = FTdataX;
            
            %% CONTINUOUS
            cfg.start = 5;
            cfg.end = 5;    % TRUNCATE
            cfg.hpfilt = hpfilt;
            FTdata.cleancont = preprocess_cont_stimex_040816(cfg,sFTdata);
            FTdata.raw = sFTdata;
            FTdata.stimfreq = sFTdata.stimfreq;
            %         FTdata.stimside = sFTdata.stimside;
            FTdata.details = sFTdata.details;
            mkdir([R.analysispath R.pipestamp '\data\processed\'])
            save([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
        end
    end
end
%end
