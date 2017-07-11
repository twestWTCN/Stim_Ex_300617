function D = dbs_LFP_stim_prepare_TW(initials, drug)

druglbl = {'off', 'on'};

keep = 0;
tsss = 1;

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    D = [];
    return
end
%%
if ~exist(root, 'dir')
    if ismember(root(end), {'/', '\'})
        root(end) = [];
    end
    [p, p1] = fileparts(root);
    if ~exist(p, 'dir')
        if ismember(p(end), {'/', '\'})
            p(end) = [];
        end
        [p2, p3] = fileparts(p);
        if ~exist(p2, 'dir')
            if ismember(p2(end), {'/', '\'})
                p2(end) = [];
            end
            [p4, p5] = fileparts(p2);
            res = mkdir(p4, p5);
        end
        res = mkdir(p2, p3);
    end
    res = mkdir(p, p1);
end

cd(root);
res = mkdir('SPMstim_LFPonly');
cd('SPMstim_LFPonly');

fD = {};
%%
origsens  = [];
origfid   = [];
fixedsens = [];
fixedfid  = [];
for f = 1:numel(files)
    if ~strncmpi('STIM', seq{f}, 4);
        continue;
    end
    
    % =============  Conversion =============================================
    S = [];
    S.dataset = files{f};
    S.channels = details.chanset;
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.conditionlabels = seq{f};
    S.mode = 'continuous';
    S.outfile = ['spmeeg' num2str(f) '_' spm_file(S.dataset,'basename')];
    
    if details.brainamp
        D = dbs_meg_brainamp_preproc(S);
    else
        D = spm_eeg_convert(S);
    end
    
    
    lblorig = {'LFP_L0R0', 'LFP_R01',  'LFP_R12', 'LFP_R23', 'LFP_L01', 'LFP_L12', 'LFP_L23'};
    lblnew  = { 'STIM', 'LFP_STIM', 'LFP_CLEAN', 'Unused', 'LFP_CONTRA_01', 'LFP_CONTRA_12', 'LFP_CONTRA_23'};
    %     end
    D = chanlabels(D, D.indchannel(lblorig), lblnew);
    
    D = chantype(D, strmatch('LFP', D.chanlabels), 'LFP');
    S = [];
    S.D = D;
    S.channels = lblnew;
    D = spm_eeg_crop(S);
    D = fname(D,[initials '_' seq{f}]);
    save(D);
end