function extract_continuous_loop_210616(R)
for sub = 1:length(R.subnames)
    for drug = 0:1 
        dbs_meg_stim_prepare_spm12_300616(R.subnames{sub},drug)
%          dbs_meg_rest_prepare_spm12(subnames{sub},drug)
    end
end