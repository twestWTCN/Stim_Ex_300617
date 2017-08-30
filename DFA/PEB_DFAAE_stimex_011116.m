function [] = PEB_DFAAE_stimex_011116(R)
% numbands = length(R.bandnames);
for stfq = 2 %:length(R.stimfreq)
    for sub  = 12 % 1:length(R.subnames)
        hemin = {'L','R'};
        for side = 1 % 1:2
            load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            for srcloc = 3 %find(strncmp(R.sourcenames,'LFP_CONTRA',9))
                DFAStore = []; boxStore = []; pebStore = [];
                xclean = FTdata.cleancont.trial{1};
                inds = find(strncmpi([hemin{side} '_' R.sourcenames{srcloc}], FTdata.freqPow.label,length(R.sourcenames{srcloc})));
                bwid = 5; BF_r = R.dfaae.BF_r; fsamp = FTdata.cleancont.fsample;
                if ~isempty(inds)
                    powfreq = 14:2:20; 
                    for i = 1:length(inds)
                        parfor band = 1:length(powfreq)
                            x1 = xclean(inds(i),:);
                            % Find PS-DFA
                            cfreq = powfreq(band);
                            lf = cfreq - bwid/2; hf = cfreq + bwid/2;
                            [DFAStore(i,band) boxStore(:,i,band) pebStore(:,i,band) varfeat(i,band) ARCoeff(i,band)] = dfaanaly(x1,lf,hf,fsamp,BF_r);
                        end
                    end
                    
                    FTdata.DFAAE.(R.sourcenames{srcloc}).DFAStore = DFAStore;
                    FTdata.DFAAE.(R.sourcenames{srcloc}).boxStore = squeeze(mean(mean(boxStore,3),2));
                    FTdata.DFAAE.(R.sourcenames{srcloc}).peb = squeeze(pebStore(1,:,:));
                    FTdata.DFAAE.(R.sourcenames{srcloc}).varfeat = varfeat;
                    FTdata.DFAAE.(R.sourcenames{srcloc}).ARCoeff = ARCoeff;
                    
                    pebv = squeeze(pebStore(1,:,:));
                    DFAcorr = DFAStore;
%                     DFAcorr(pebv<BF_r) = NaN;
                    FTdata.DFAAE.(R.sourcenames{srcloc}).DFAcorr = DFAcorr;
                end
                clear DFAStore boxStore pebStore
            end
            save([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
            disp([sub R.stimfreq(stfq) side srcloc])
        end
    end
end
end
function [A B C D E] = dfaanaly(x1,lf,hf,fsamp,BF_r)
% close all
x1_filt = filterEEG(x1,fsamp,lf,hf,6*fix(fsamp/lf)); % bandpass filter
x1AE = abs(hilbert(x1_filt));
maxFrac = 10; minBS = (1/lf)*12;
DFAP = [fsamp minBS (length(x1AE)/maxFrac)/fsamp 50 0];
[bmod win evid alpha] = peb_dfa_cohproj_090616(x1AE,DFAP,BF_r,0);
if  evid < BF_r
    rej = 1;
    %     alpha = NaN;
else
    rej = 0;
end
m = ar(x1AE,1);
A = [alpha]; B = [lf hf minBS]; C = [evid]; D = std(x1AE); E = getpvec(m);
end