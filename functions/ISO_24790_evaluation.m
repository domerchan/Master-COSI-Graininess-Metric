% Evaluation of the graininess metric defined in ISO/IEC 24790
%
% Outputs:  - subplot with ROI of each sample and its graininess score
%           - subplot with ROI of each sample converted to CIE Y
%           - scatter plot of final graininess scores against the score
%           assigned in the psychophysical experiment of each sample
%
% Other m-files required: graininess_evaluation_24790.m
% Subfunctions: none
% MAT-files required: N_Set_B.mat
%
% By: 
% Doménica Alejandra Merchán García
% 13-05-2024; last modified: 12-07-2024 
%--------------------------------------------------------------------------
close all;

samples_ID = ["66885","90444","97351","59692","44801","95316","04311","08871","98361","23617"];
path_to_files = "../samples/Group 1/Set B/RGB_1200_DPI/";

G24790_Set_B = zeros(1,10);
Y = zeros(540,540,10);
ROI = [];
f = figure;
f.Position = [100 600 1200 400];
x = 3500; y = 500;

for i = 1:10
    subplot(2,5,i);
    file = strcat(path_to_files,samples_ID(i),'.tif');
    [G24790_Set_B(i), ROI, Y(:,:,i)] = graininess_evaluation_24790(file, x, y);
    imshow(ROI);
    title(strcat(samples_ID(i),'| g=',num2str(G24790_Set_B(i))));
end
sgtitle(strcat('Samples ROI centered in (',num2str(x),',',num2str(y),[') ' ...
    'with their graininess score.']))
  
f = figure;
f.Position = [100 100 1200 400];
for i = 1:10
    subplot(2,5,i);
    imshow(Y(:,:,i),[]);
    title(strcat(samples_ID(i),'| g=',num2str(G24790_Set_B(i))));
end
sgtitle(strcat('ROI converted to CIE Y'))

figure();
scatter(G24790_Set_B,mean(N_Set_B),'filled');
xlim([2 7]);
ylim([0 10]);
corr = corrcoef(G24790_Set_B,mean(N_Set_B));
grid();
hold on;
p = polyfit(G24790_Set_B,mean(N_Set_B),1);
plot(2:7,polyval(p,2:7));
grid("on");
title('SET B: ISO 24790 graininess metric vs HVS graininess score');
subtitle(['Pearson Correlation: ', num2str(corr(1,2))])
legend('','Linear Regression');
legend("Location","southeast");