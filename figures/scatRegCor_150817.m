% function scatRegCor_150817(R)
clear; close all
R = buildheader_stimex;
cmap = linspecer(3);
vartest = {'PEB','Tot_off','trem_off'};
vartestNames = {'PEB Score','Total OFF UPDRS','Tremor OFF UPDRS'};

load([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'],'a')
for stfq = 1:length(R.stimfreq)
    rows = a.cond==R.stimfreq(stfq) & a.contact == 2;
    vars = {'subject','side','DFA','PEB','Tot_off','trem_off','tot_on','trem_on'};
    T3 = a(rows,vars);
    for i = 1:length(vartest)
        Y = []; X = [];
        for side = 1:2
            rows = T3.side == side;
            T = varfun(@nanmean,T3(rows,:),'InputVariables','DFA',...
                'GroupingVariables','subject');
            Y = [Y; table2array(T(:,3))];
            
            T = varfun(@nanmean,T3(rows,:),'InputVariables',vartest(i),...
                'GroupingVariables','subject');
            X = [X; table2array(T(:,3))];
        end
        %         Y = table2array(T3(:,'DFA'));
        %         X = table2array(T3(:,vartest(i)));
        
        figure
        aplot(1) = scatter(X,Y,100,repmat(cmap(i,:),size(X)),'LineWidth',1.5,'Marker','+');
        hold on
        X = [ones(length(X),1) X];
        
        % NaN elimination
        Y(isnan(X(:,2)),:) = [];
        X(isnan(X(:,2)),:) = [];
        X(isnan(Y),:) = [];
        Y(isnan(Y),:) = [];
        
        b = X\Y;
        yCalc = X*b;
        [r p] = corr(X(:,2),Y,'type','Pearson')
        if p<0.05
            aplot(2) = plot(X(:,2),yCalc,'Color',cmap(i,:),'LineWidth',3);
        end
        ylabel('Corrected DFA')
        xlabel(vartestNames(i))
        annotation(gcf,'textbox',...
            [0.55 0.16 0.30 0.18],...
            'String',{[sprintf('R2: %.3f',r^2)];[sprintf('P: %.3f',p)]},...
            'HorizontalAlignment','right',...
            'FontSize',18,...
            'LineStyle','none',...
            'FitBoxToText','off');
        %         legend(aplot,{'Scatter',['LinReg, r = ' num2str(r) ' , P = ' num2str(p)]})
        title(['DFA vs ' vartestNames(i)])
        grid on
        clear aplot
    end
end