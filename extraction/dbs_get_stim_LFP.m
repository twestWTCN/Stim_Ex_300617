function D1 = dbs_get_stim_LFP(S)
% Fuse simultaneously recorded MEG and EEG datasets based on a common
% reference noise channel
% FORMAT  D = presma_brainamp_preproc(S);
%
% S           - input structure (optional)
% (optional) fields of S:
%   S.dataset       - name of the MEG dataset
%   S.ref1     - name of the reference channel in EEG dataset
%   S.ref2     - name of the reference channel in MEG dataset
%
% D        - MEEG object (also written to disk, with a 'u' prefix)
%__________________________________________________________________________
% Copyright (C) 2011 Wellcome Trust Centre for Neuroimaging
%
% Vladimir Litvak
% $Id: dbs_meg_brainamp_preproc.m 154 2017-05-05 13:48:15Z vladimir $

SVNrev = '$Rev: 154 $';

%-Startup
%--------------------------------------------------------------------------
spm('FnBanner', mfilename, SVNrev);
spm('FigName','Brainamp preproc'); spm('Pointer','Watch');

if nargin == 0
    S = [];
end

%-Get MEEG objects
%--------------------------------------------------------------------------
if ~isfield(S, 'dataset')
    [dataset, sts] = spm_select(1, '.*', 'Select MEG dataset');
    if ~sts, dataset = []; return; end
    S.dataset = dataset;
end

if ~isfield(S, 'ref1')
    S.ref1 = 'Noise';
end

if ~isfield(S, 'ref2')
    S.ref2 = 'UADC001';
end

[p, f] = fileparts(S.dataset);

if ~isempty(strfind(p, '.ds'))
    p = spm_str_manip(p, 'h');
end

S1 = [];
S1.mode = 'continuous';
S1.checkboundary = 0;

S1.dataset = fullfile(p, dbs_meg_brainamp_file(S.dataset));
D1 = spm_eeg_convert(S1);
S1.dataset = S.dataset;
S1.saveorigheader = 1;
D1 = chantype(D1, ':', 'LFP');save(D1);
