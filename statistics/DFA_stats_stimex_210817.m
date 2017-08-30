function DFA_stats_stimex_011116(R)
% numbands = length(R.bandnames);
statstack = [];
updrsind = [3 5;2 4];
sRev = [2 1];
conInds = {'01','12','23'};
for sub  = 1:length(R.subnames)
    for stfq = 1:length(R.stimfreq)
        hemin = {'L','R'};
        for side = 1:2
            load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            for i = 1:3
                tmp = squeeze(R.ind2use(sub,stfq,side,:));
                if tmp == 1
                    srcloc = ['LFP_CONTRA_' conInds{i}]
                    
                    DFA = FTdata.DFAAE.LFP_CONTRA.DFAcorr';
                    [a b] = size(DFA);
                    DFAlong = reshape(DFA',[],1);
                    
                    PEB = FTdata.DFAAE.(R.sourcenames{srcloc}).peb';
                    [a b] = size(PEB);
                    PEBlong = reshape(PEB',[],1);
                    
                    [a2 b2] = size(DFAlong);
                    % [subject side cond contact freq DFA PEB]
                    tabd = [repmat(sub,a2,b2) repmat(side,a2,b2) repmat(R.stimfreq(stfq),a2,b2) repmat((1:size(DFA,2))',a2/size(DFA,2),b2) reshape(repmat(1:a,b,1),[],1) DFAlong PEBlong];
                    updrs = FTdata.details.UPDRS;
                    % {'age' 'disdur' 'LDE' 'Tot_off' 'Trunc_off' 'arm_off' 'trem_off' 'Trunc_on' 'arm_on' 'trem_on'}
                    updrsline = [FTdata.details.age FTdata.details.disdur FTdata.details.LDE updrs(1,1) updrs(1,6) updrs(1,updrsind(sRev(side),:)) updrs(2,1) updrs(2,6) updrs(2,updrsind(sRev(side),:)) ];
                    tabd = [tabd repmat(updrsline,size(tabd,1),1)];
                    statstack = [statstack; tabd];
                else
                    tabd = [repmat(sub,a2,b2) repmat(side,a2,b2) repmat(R.stimfreq(stfq),a2,b2) nan(a2,4)];
                    tabd = [tabd repmat(nan(size(updrsline)),size(tabd,1),1)];
                    disp('ERROR: Data not found??')
                    statstack = [statstack; tabd];
                end
            end
        end
    end
end
header = {'subject' 'side' 'cond' 'contact' 'freq' 'DFA' 'PEB' 'age' 'disdur' 'LDE' 'Tot_off' 'Trunc_off' 'arm_off' 'trem_off' 'tot_on' 'Trunc_on' 'arm_on' 'trem_on'};
a = array2table(statstack,'VariableNames',header);
blist = a(a.PEB<R.dfaae.BF_r,'PEB');
a(a.PEB<R.dfaae.BF_r,'DFA') = array2table(NaN(size(blist)));
%% CORRECT FOR DFA!
writetable(a,[R.analysispath R.pipestamp '\data\stat_table\dfastatsupdrs.xls'])
save([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'],'a')
