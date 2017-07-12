function [files, sequence, root, details] =dbs_subjects(initials, on)

if length(initials)>=4 && isequal(initials(1:4), 'PLFP')
    [files, sequence, root, details] = dbs_subjects_berlin(initials, on);
elseif isequal(initials(1:2), 'HB')
    [files, sequence, root, details] = dbs_subjects_hamburg(initials, on);
elseif length(initials)>=4 && isequal(initials(1:4), 'NACC')    
    [files, sequence, root, details] = nacc_subjects(initials);
elseif length(initials)>=3 && isequal(initials(1:3), 'WUE')    
    [files, sequence, root, details] = dbs_subjects_wue(initials);    
elseif length(initials)>=2 && isequal(initials(1:2), 'MG')    
    if ~on
        error('No off drug condition for healthy subjects');
    end
    [files, sequence, root, details] = dbs_subjects_mice(initials); 
% elseif length(initials)>=6 && isequal(initials(4:6), 'VTA')  
%     [files, root, details] = vta_subjects(initials);
%     sequence = {};
else
    [files, sequence, root, details] = dbs_subjects_london(initials, on);
end


