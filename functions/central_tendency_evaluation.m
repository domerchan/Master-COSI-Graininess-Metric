% Evaluation of central tendency metrics
%
% Outputs:  - plot of scores measured with different central tendency 
%           metrics 
%           - bar chart of correlation coefficients between SCG calculated
%           with different central tendency metrics and MOS
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required:   N_Set_MediaWedge.mat 
%                       SCG_MediaWedge.mat
%
% By: 
% Doménica Alejandra Merchán García
% 25-06-2024; last modified: 27-06-2024 
%--------------------------------------------------------------------------
close all;

SCG = SCG_MediaWedge(:,[21,28,11,12,1,16,30,17,19,18,22,15,24,8,20]);
sample_names = {'21' '28' '11' '12' '1' '16' '30' '17' '19' '18' '22' '15' '24' '8' '20'};

f = figure;
f.Position = [100 100 900 400];
m = mean(N_Set_MediaWedge);
[m,order] = sort(m);
plot(m./2,'.r','DisplayName', 'MOS')
hold on
m = mode(SCG);
plot(m(order),'*k','DisplayName', 'Mode')
m = mean(SCG);
plot(m(order),'ok','DisplayName', 'Mean')
m = prctile(SCG,25);
plot(m(order),'>k','DisplayName', 'Q1')
m = prctile(SCG,50);
plot(m(order),'+k','DisplayName', 'Q2')
m = prctile(SCG,75);
plot(m(order),'pentagramk','DisplayName', 'Q3')
m = prctile(SCG,85);
plot(m(order),'xk','DisplayName', '85th %ile')
m = prctile(SCG,95);
plot(m(order),'<k','DisplayName', '95th %ile')
legend()
xlim([0 16])
xticks([1:1:15])
xticklabels(sample_names(order))
legend("Location","northwest");
ylabel('Graininess score');
xlabel('Samples');

figure();
c = corrcoef(mode(SCG),mean(N_Set_MediaWedge));
corr(1) = c(1,2);
c = corrcoef(mean(SCG),mean(N_Set_MediaWedge));
corr(2) = c(1,2);
c = corrcoef(prctile(SCG,25),mean(N_Set_MediaWedge));
corr(3) = c(1,2);
c = corrcoef(prctile(SCG,50),mean(N_Set_MediaWedge));
corr(4) = c(1,2);
c = corrcoef(prctile(SCG,75),mean(N_Set_MediaWedge));
corr(5) = c(1,2);
c = corrcoef(prctile(SCG,85),mean(N_Set_MediaWedge));
corr(6) = c(1,2);
c = corrcoef(prctile(SCG,95),mean(N_Set_MediaWedge));
corr(7) = c(1,2);

names = {'Mode', 'Mean', 'Q1', 'Q2', 'Q3', '85th %ile', '95th %ile'};
bar(corr,0.4,'k','FaceAlpha',0.7);
ylim([0.90 1]);
ylabel('Correlation coefficient');
set(gca, 'xticklabel',names);
xt = get(gca, 'XTick');
text(xt, corr, num2cell(round(corr,3)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
grid on