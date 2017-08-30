%function [] = boxplot_STIMEX_table(R)
close all
load([R.analysispath R.pipestamp '\data\stat_table\stattab.mat'])
A = table2array(a);
condcombs= {'Stim 0Hz' 'Stim 130 Hz' 'Both freqs'};
head = a.Properties.VariableNames;
for j = 1:3
    for i = 1:length(head);
        if j <3
            J = j;
            rows = a.contact==2 & a.cond == j;
        else
            rows = a.contact==2;
        end
        select = table2array(a(rows,{'DFA',head{i}}));
        X = select(:,1); Y = select(:,2);
        figure(i)
        scatter(X,Y);
        [r p] = corr(select(:,1),select(:,2),'rows','complete','type','Spearman');
        xlabel('DFA'); ylabel(head{i})
        title(['Middle Contact correlations and ' condcombs{j}])
        [xCalc yCalc b Rsq] = linregress(X,Y);
        [xCalc,I] = sort(xCalc,1,'ascend');
        yCalc = yCalc(I);
        hold on
        plot(xCalc,yCalc,'k','linewidth',2)
        grid on
        annotation(gcf,'textbox',[0.73 0.16 0.15 0.10],'String',{sprintf('R^2 = %0.3f',Rsq); sprintf('R = %0.3f',r); sprintf('P = %0.3f',p)},...
            'FitBoxToText','off','LineStyle','none');
        saveallfiguresFIL([R.analysispath R.pipestamp '\results\init_correlations\init_corrs_' condcombs{j} '_DFA_' head{i} '_' ],'-jpg',0,'-r250'); close all
    end
end
%% Collapsed
rows =   a.cond == 1 & a.freq == 4;
select = a(rows,{'subject','side','DFA','Tot_off'});
a_col = varfun(@nanmean,select,'InputVariables',{'DFA','Tot_off'},'GroupingVariables',{'subject','side'})
X = a_col.nanmean_DFA; Y = a_col.nanmean_Tot_off;

figure
scatter(X,Y);
[r p] = corr(X,Y,'rows','complete','type','Pearson');
xlabel('DFA'); ylabel('UPDRS Tot')

[xCalc yCalc b Rsq] = linregress(X,Y)
[xCalc,I] = sort(xCalc,1,'ascend');
yCalc = yCalc(I);
hold on
plot(xCalc,yCalc,'k','linewidth',2)
annotation(gcf,'textbox',[0.73 0.16 0.15 0.10],'String',{sprintf('R^2 = %0.3f',Rsq); sprintf('R = %0.3f',r); sprintf('P = %0.3f',p)},...
    'FitBoxToText','off','LineStyle','none');
%% Box Plot

select = a(:,{'subject','DFA','cond','PEB'});
