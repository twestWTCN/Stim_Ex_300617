function R = includeCoding(R)
% for sub  = 1:length(R.subnames)
%     for stfq = 1:length(R.stimfreq)
%         hemin = {'L','R'};
%         for side = 1:2
%             load([R.analysispath R.pipestamp '\data\processed\' R.subnames{sub} '_OFFdrug_' R.pipestamp '_' hemin{side} '_stim' num2str(R.stimfreq(stfq)) 'Hz.mat'],'FTdata')
%             try
%                 for srcloc = find(strncmp(R.sourcenames,'LFP_CONTRA',9))
% 
                    
% Use
%   Columns 1 through 8
% 
%     'LN_C05'    'LN_C06'    'LN_C09'    'LN_C10'    'LN_C12'    'LN_C16'    'LN_C17'    'LN_C20'
% 
%   Columns 9 through 12
% 
%     'LN_C21'    'LN_C22'    'LN_C23'    'LN_C24'

ind2use = zeros(length(R.subnames),3,2,3);
%ind2use(sub,freq,side,contact)
ind2use(1,[1 2],1,:) = 1; % LN_CO5; 0/5 Hz/Left/All Cont.

ind2use(2,[1 3],:,:) = 1; % LN_CO5; 0/0 130 Hz/Both/All Cont.
ind2use(2,[2],1,:) = 1; % LN_CO5; 0/5 Hz/Left/All Cont.

ind2use(4,:,1,:) = 1; % LN_C10; 0/All/Left/All Cont.
ind2use(4,:,2,[2 3]) = 1; % LN_C10; 0/All/Right/12'23

ind2use(5,:,1,:) = 1; % LN_C12; 0/All/Left/All Cont.
ind2use(5,:,2,2) = 1; % LN_C12; 0/All/Right/12

ind2use(6,:,1,:) = 1; % LN_C16; 0/All/Left/All Cont.
ind2use(6,:,2,1) = 1; % LN_C16; 0/All/Right/01

ind2use(7,[1 2],1,:) = 1; % LN_C17; 0/0 5 Hz/Left/All Cont.
ind2use(7,:,2,:) = 1;     % LN_C17; 0/All/Right/All Cont.

ind2use(8,:,1,:) = 1;     % LN_C20; 0/All/Left/All Cont.
ind2use(8,[1 2],2,:) = 1; % LN_C20; 0/0 5 Hz/Right/All Cont.

ind2use(9,:,:,:) = 1;     % LN_C21; 0/All/Both/All Cont.

ind2use(10,:,2,:) = 1;     % LN_C22; 0/All/Right/All Cont.

ind2use(11,:,:,:) = 1;     % LN_C23; 0/All/Both/All Cont.

ind2use(12,:,1,:) = 0;     % LN_C24; 0/0 5/Left/All Cont.
ind2use(12,:,2,:) = 1;     % LN_C24; 0/All/Right/All Cont.

R.ind2use = ind2use;
R.ind2useCode = {'sub','freq','side','contact'};