function [trn trdets trstim trdef] = stimex_trialselect(sub)
% {'LN_C04'  'LN_C05'  'LN_C06'  'LN_C08'  'LN_C12'  'LN_C16'  'LN_C17'  'LN_C20'  'LN_C21'  'LN_C22'  'LN_C23'  'LN_C24'}
% {'ON'       'ON'      'OFF'       'ON'     'OFF'     'OFF'      'OFF'    'OFF'     'OFF'     'OFF'     'OFF'     'OFF'
switch sub
    case 'LN_C04'
        trn = [2 4];
        trdets = {'RStim' 'LStim'};
    case 'LN_C05'
        trn = [2 4];
        trdets = {'RStim' 'LStim'};
    case 'LN_C06'
        trn = [2:5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[5 20],[0 130],[5 20],[0 130]};
        trdef = {[
            90  263	268	462
            0	210	218	389
            119	279	285	481
            0	198	206	387
            ]};
    case 'LN_C08'
        trn = [2 4];
        trdets = {'RStim' 'LStim'};
    case 'LN_C12'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[20 130],[5 0],[20 130],[5 0]};
        trdef = {[
            49	217	248	417
            50	227	228	422
            40	214	240	413
            73	247	253	453
            ]};
    case 'LN_C16'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[130 5],[20 0],[130 5],[20 0]};
        trdef = {[
            43	211	248	412
            27	202	206	406
            4	172	197	372
            40	214	218	419
            ]};
    case 'LN_C17'
        % trial 4 5Hz did not settle
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[20 5],[0 130],[20 5],[0 130]};
        trdef = {[
            42	214	218	412
            0	195	199	382
            38	217	223	417
            0	204	207	390
            ]};
    case 'LN_C20'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[5 130],[20 0],[5 130],[20 0]};
        trdef = {[
            45	216	239	412
            36	211	218	417
            43	222	240	417
            44	218	222	421
            ]};
    case 'LN_C21'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[5 130],[20 0],[5 130],[20 0]};
        trdef = {[
            77	250	268	448
            42	216	221	419
            64	243	258	444
            65	245	248	450
            ]};
    case 'LN_C22'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[130 20 ],[5 0],[130 20],[5 0]};
        trdef = {[
            15	215	222	388
            45	218	224	420
            99	272	279	476
            62	216	222	418
            ]};
    case 'LN_C23'
        trn = [2 3 4 5];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[130 20 ],[5 0],[130 20],[5 0]};
        trdef = {[
            67	248	252	449
            34	211	216	416
            43	215	224	416
            38	215	218	414
            ]};
    case 'LN_C24'
        trn = [2 3 4];
        trdets = {'RStim' 'RStim' 'LStim' 'LStim'};
        trstim = {[0 130],[5 20],[0 130]};
        trdef = {[
            0	237	244	436
            0	88	90	256
            0	195	197	387
            ]};
end