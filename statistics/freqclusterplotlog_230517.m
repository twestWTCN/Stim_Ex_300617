function [ax] = freqclusterplotlog_230517(OFF,fxA,titular,ylab,ylimd,cmap,dir)
if nargin<5
    alpha = 0.05;
end
if nargin<6
    titular = 'spectral stats for unknown analysis';
end
if nargin<6
    ylab = 'scaler';
end
if nargin <10
    dir = 0;
end
if size(fxA,1)>size(fxA,2)
    fxA = fxA';
end

lineind = find(fxA>48.5 & fxA<51.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));

lineind = find(fxA>98.5 & fxA<101.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));

lineind = find(fxA>148.5 & fxA<151.5);
OFF(:,lineind) = NaN(size(OFF,1),size(lineind,2));

%
fxA =log10(fxA);
OFF= log10(OFF);

if dir == 1
    ax = plot(repmat(fxA,size(OFF,1),1)',OFF','Color',cmap(1,:),'LineStyle','-','linewidth',1.5);    
else
    ax = plot(repmat(fxA,size(OFF,1),1)',OFF','Color',cmap(1,:),'LineStyle','-','linewidth',1.5);    
end
if ~isempty(ylimd)
    ylim(log10(ylimd));
end
xlim(log10([4 150]));
xlabel('log10 Frequency (Hz)'); ylabel(ylab); title(titular);
if  strcmp(getenv('COMPUTERNAME'), 'SFLAP-2') == 1
    x = gca;
    for i = 1:size(x.XTick,2)
        xtlab{i} = num2str(10^(x.XTick(i)),2);
    end
    x.XTickLabel = xtlab;
end
grid on
hold on