% Evaluation of the graininess metric defined in ISO/TS 18621-22
%
% Outputs:  - scatter plot of final graininess scores against the score
%           assigned in the psychophysical experiment of each sample
%
% Other m-files required: graininess_evaluation_18621.m
% Subfunctions: none
% MAT-files required: N_Set_B.mat 
%                     N_Set_C.mat
%
% By: 
% Doménica Alejandra Merchán García
% 13-05-2024; last modified: 12-07-2024 
%--------------------------------------------------------------------------
close all;

%Set B evaluation
samples_ID = ["66885","90444","97351","59692","44801","95316","04311","08871","98361","23617"];
path_to_files = "../samples/Group 1/Set B/LAB_600_DPI/";

pts1 = [[2095,265];[2098,262];[2101,277];[2101,280];[2098,279];...
    [2103,276];[2105,273];[2097,297];[2114,269];[2097,279]];
pts2 = [[2173,1872];[2168,1883];[2178,1885];[2174,1889];[2159,1907];...
    [2174,1894];[2174,1890];[2158,1907];[2179,1886];[2162,1886]];

cols = 2;
rows = 7;

SCG_Set_B = zeros(cols*rows,10);

for i = 1:10
    file = strcat(path_to_files,samples_ID(i),'.tif');
    SCG_Set_B(:,i) = graininess_evaluation_18621(file,cols,rows,pts1(i,:),pts2(i,:));
end


figure();
scatter(mean(SCG_Set_B),mean(N_Set_B),'filled');
xlim([0.4 1.4]);
ylim([0 10]);
corr = corrcoef(mean(SCG_Set_B),mean(N_Set_B));
grid();
hold on;
p = polyfit(mean(SCG_Set_B),mean(N_Set_B),1);
plot(0:2,polyval(p,0:2));
grid("on");
title('SET B: ISO 18621-22 S_C_G metric vs HVS graininess score');
subtitle(['Pearson Correlation: ', num2str(corr(1,2))])
xlabel('ISO/TS 18621-22 color graininess score (S_C_G)')
ylabel('MOS')
legend('','Linear Regression');
legend("Location","southeast");


% Set C evaluation
samples_ID = ["24091","06005","27120","45949","74021","73740","56546","13880","22628","55823"];
path_to_files = "../samples/Group 1/Set C/LAB_600_DPI/";

pts1 = [[4272,129];[4257,145];[4266,149];[4265,154];[4237,143];...
    [4248,153];[4245,139];[4264,124];[4267,153];[4267,147]];
pts2 = [[4352,2414];[4343,2437];[4342,2467];[4329,2472];[4325,2471];...
    [4326,2453];[4325,2451];[4358,2442];[4341,2463];[4357,2455]];

cols = 2;
rows = 12;

SCG_Set_C = zeros(cols*rows,10);

for i = 1:10
    file = strcat(path_to_files,samples_ID(i),'.tif');
    SCG_Set_C(:,i) = graininess_evaluation_18621(file,cols,rows,pts1(i,:),pts2(i,:));
end


figure();
scatter(mean(SCG_Set_C),mean(N_Set_C),'filled');
xlim([0.4 1.4]);
ylim([0 10]);
corr = corrcoef(mean(SCG_Set_C),mean(N_Set_C));
grid();
hold on;
p = polyfit(mean(SCG_Set_C),mean(N_Set_C),1);
plot(0:2,polyval(p,0:2));
grid("on");
title('SET B: ISO 18621-22 S_C_G metric vs HVS graininess score');
subtitle(['Pearson Correlation: ', num2str(corr(1,2))])
xlabel('ISO/TS 18621-22 color graininess score (S_C_G)')
ylabel('MOS')
legend('','Linear Regression');
legend("Location","southeast");