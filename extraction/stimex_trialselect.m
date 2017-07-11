function [trn,trstim,trdef,details] = stimex_trialselect(sub)
% details.age  = age (years)
% details.gender  = male/female
% details.disdur  = age (years)
% details.LDE = DA dose
% details.UPDRS = OFF: total RAR LAR RTrem LTrem Trunc
%                 ON:  total RAR LAR RTrem LTrem Trunc

switch sub
    case 'LN_C05'
        trn = [2:5];
        trstim = {[0 130],[5 20],[0 130],[5 20]};
        trdef = {[
            0   198	210	392
            111	260	288	471
            0	206	218	387
            98	240	252	450
            ]};
        details.age = 67;
        details.gender = 'M';
        details.disdur = 7;
        details.LDE = 2840;
        details.UPDRS = [43 12 14 0 10 7;
            19 7  6  0 0  3];
        details.sub = sub;
    case 'LN_C06'
        trn = [2:5];
        trstim = {[5 20],[0 130],[5 20],[0 130]};
        trdef = {[
            90  263	268	462
            0	210	218	389
            119	279	285	481
            0	198	206	387
            ]};
        details.age = 67;
        details.gender = 'M';
        details.disdur = 8;
        details.LDE = 200;
        details.UPDRS = [21 5 6 0 0 6;
            17 4 6 0 0 6];
        details.sub = sub;
    case 'LN_C09'
        trn = [2:5];
        trstim = {[130 5],[20 0],[130 5],[20 0]};
        trdef = {[
            71 253 257 446
            68 241 244 442
            74 252 274 452
            85 262 265 464
            ]};
        details.age = 65;
        details.gender = 'M';
        details.disdur = 14;
        details.LDE = 960;
        details.UPDRS = [28 3 6 3 3 8;
            11 0 1 2 0 4];
        details.sub = sub;
    case 'LN_C10'
        trn = [2:5];
        trstim = {[5 130],[20 0],[5 130],[20 0]};
        trdef = {[
            39 213 252 415
            75 248 250 450
            90 267 290 467
            170 336 338 540
            ]};
        
        details.age = 43;
        details.gender = 'M';
        details.disdur = 9;
        details.LDE = 1400;
        details.UPDRS = [63 17 19 3 2 12;
            30 4 13 11 0 1];
        
        details.sub = sub;
    case 'LN_C12'
        trn = [2:5];
        trstim = {[20 130],[5 0],[20 130],[5 0]};
        trdef = {[
            49	217	248	417
            50	227	228	422
            40	214	240	413
            73	247	253	453
            ]};
        details.age = NaN;
        details.gender = NaN;
        details.disdur = NaN;
        details.LDE = NaN;
        details.UPDRS = [NaN NaN NaN NaN NaN NaN;
            31 8 12 1 2 5];
        details.sub = sub;
        
    case 'LN_C16'
        trn = [2:5];
        trstim = {[130 5],[20 0],[130 5],[20 0]};
        trdef = {[
            43	211	248	412
            27	202	206	406
            4	172	197	372
            40	214	218	419
            ]};
        details.age = 60;
        details.gender = 'M';
        details.disdur = 8;
        details.LDE = 456;
        details.UPDRS = [46 12 11 6 3 8;
            23 4 11 2 1 4];
        details.sub = sub;
        
    case 'LN_C17'
        % trial 4 5Hz did not settle
        trn = [2:5];
        trstim = {[20 5],[0 130],[20 5],[0 130]};
        trdef = {[
            42	214	218	412
            0	195	199	382
            38	217	223	417
            0	204	207	390
            ]};
        details.age = 70;
        details.gender = 'M';
        details.disdur = 10;
        details.LDE = 900;
        details.UPDRS = [34 8 10 2 2 7;
            34 6 11 2 3 8];
        details.sub = sub;
    case 'LN_C20'
        trn = [2 3 4 5];
        trstim = {[5 130],[20 0],[5 130],[20 0]};
        trdef = {[
            45	216	239	412
            36	211	218	417
            43	222	240	417
            44	218	222	421
            ]};
        details.age = 41;
        details.gender = 'M';
        details.disdur = 6;
        details.LDE = 1020;
        details.UPDRS = [50 14 15 2 2 10;
            48 14 18 0 1 11];
        details.sub = sub;
        
    case 'LN_C21'
        trn = [2:5];
        trstim = {[130 5],[20 0],[130 5],[20 0]};
        trdef = {[
            75	250	268	448
            42	216	221	419
            64	243	258	444
            65	245	248	450
            ]};
        details.age = 58;
        details.gender = 'M';
        details.disdur = 12;
        details.LDE = 1200;
        details.UPDRS = [38 13 10 0 0 9;
            13 6 3 1 0 0];
        details.sub = sub;
    case 'LN_C22'
        trn = [2 3 4 5];
        trstim = {[130 20],[5 0],[130 20],[5 0]};
        trdef = {[
            15	215	222	388
            45	218	224	420
            99	272	279	476
            62	216	222	418
            ]};
        details.age = 68;
        details.gender = 'M';
        details.disdur = 12;
        details.LDE = 1370;
        details.UPDRS = [52 8 14 4 5 12;
            34 7 4 2 2 9];
        details.sub = sub;
    case 'LN_C23'
        trn = [2 3 4 5];
        trstim = {[130 20 ],[5 0],[130 20],[5 0]};
        trdef = {[
            67	248	252	449
            34	211	216	416
            43	215	224	416
            38	215	218	414
            ]};
        details.age = 60;
        details.gender = 'M';
        details.disdur = 12;
        details.LDE = 1300;
        details.UPDRS = [33 7 8 7 2 4;
            22 3 4 6 1 4];
        details.sub = sub;
    case 'LN_C24'
        trn = [2 3 4];
        trstim = {[0 130],[5 -1],[0 130]};
        trdef = {[
            0	237	244	436
            90	256	256	257
            0	195	197	387
            ]};
        details.age = 59;
        details.gender = 'M';
        details.disdur = 13;
        details.LDE = 1900;
        details.UPDRS = [48 8 10 5 7 9;
            27 5 8 1 3 8];
        details.sub = sub;
        
end