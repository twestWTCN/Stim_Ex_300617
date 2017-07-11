function extract_continuous_loop_210616(R)
drind = [1 0]; % [ON OFF]
for sub = 1:length(R.subnames)
    for drug = 1:2
        if R.subDrug{sub}(drug) == 1
%         dbs_meg_stim_prepare_spm12(R.subnames{sub},drind(drug))
        dbs_LFP_stim_prepare_TW(R.subnames{sub},drind(drug))
%          dbs_meg_rest_prepare_spm12(subnames{sub},drug)
        end
    end
end