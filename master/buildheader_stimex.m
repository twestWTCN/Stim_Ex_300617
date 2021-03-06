function R = buildheader_stimex()
R.pipestamp = 'Stim_Ex_300617';
R.stimfreq = [0 5 130];
R.stimfrqname = {'0 Hz','5 Hz','130 Hz'};
R.condnames = {'0Hz','5Hz','130Hz'};
R.subnames = {'LN_C05','LN_C06','LN_C09','LN_C10','LN_C12','LN_C16','LN_C17','LN_C20','LN_C21','LN_C22','LN_C23','LN_C24'}; %

R.subDrug =  {[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1]}; % [ON OFF]


R.sourcenames = {'LFP_STIM' 'LFP_CLEAN','LFP_CONTRA'};
R.bbounds = [5 12; 13 20; 21 30]; % Bands of interest
R.FOI = [4 200]; % Frequencies of interest
R.pp.hpfilt = 4;
R.pp.lpfilt = 48;  % low pass

R.ds = 600; % sample rate to downsample to
if  strcmp(getenv('COMPUTERNAME'), 'FREE') == 1
    R.datapath = 'C:\home\data\TimExtracts280716\';
    R.analysispath = 'C:\Users\twest\Documents\Work\GitHub\';
else
    R.datapath = 'C:\home\data\TimExtracts310516\';
    R.analysispath = 'C:\Users\Tim\Documents\Work\LitvakProject\Stimulator_Experiments\Pipeline\';
end
