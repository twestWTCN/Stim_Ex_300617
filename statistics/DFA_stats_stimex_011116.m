function [] = DFA_stats_stimex_011116(R)
% numbands = length(R.bandnames);
statstack = [];
for sub  = 1:length(R.subnames)
    for cond = 1:2
        load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_stim' R.condnames{cond} '.mat'])
        for srcloc = find(strncmp(R.sourcenames,'LFP_CONTRA',9))
            DFA = FTdata.DFAAE.LFP_CONTRA.DFAStore';
            [a b] = size(DFA);
            DFAlong = reshape(DFA',[],1);
            [a2 b2] = size(DFAlong);
            tabd = [repmat(sub,a2,b2) repmat(cond,a2,b2) repmat((1:size(DFA,2))',a2/size(DFA,2),b2) reshape(repmat(1:a,b,1),[],1) DFAlong];
            statstack = [statstack; tabd]
            
            
        end
    end
end
a = 1;