function cleandata = preprocess_cont_stimex_040816(cfg,FTdata)
data = FTdata.trial{1};
for D = 1:size(data,1)
    X = data(D,:); % assign data
    
    % Interpolate NaNs
    nanx = isnan(X);
    t    = 1:numel(X);
    X(nanx) = interp1(t(~nanx), X(~nanx), t(nanx));
    
    % De-mean
    X = X - mean(X);
    
    % Truncate
    X = X(1,(cfg.start*FTdata.fsample):end-(cfg.end*FTdata.fsample)); %
    
    % High Pass
    X_hp = filtfilt(cfg.hpfilt,X);
    
    
    % Remove Suprathreshold Events
    Xdiff = abs(diff(X_hp));
    xThresh = find(Xdiff>(median(Xdiff)+prctile(Xdiff,95)));
    for i = 1:length(xThresh)
        qI = [xThresh(i)-2,xThresh(i)-1];
        if numel(find(qI)) == 2
            rep = interp1(1:2,X_hp(qI),linspace(1,2,3));
            X_hp(xThresh(i)) = rep(2);
        end
    end
    data_clean(D,:) = X_hp;
end
tvec = FTdata.time{1}(1,(cfg.start*FTdata.fsample):end-(cfg.end*FTdata.fsample));
cleandata.label = FTdata.label;
cleandata.fsample = FTdata.fsample;
cleandata.trial{1} = data_clean;
cleandata.time{1} = tvec;
