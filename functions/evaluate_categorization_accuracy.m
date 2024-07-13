function acc = evaluate_categorization_accuracy(metric_scores,thresholds,central_tendency_metric, percentile)
% calculation of the accuracy in graininess categorization based on
% proposed thresholds and psychophysical results from 58 observers in a 
% categorization experiment. 
%
% Function Inputs:
%           metric_scores:           graininess scores obtained with
%                                    objective metric, size: 
%                                    observations x samples
%           thresholds:              thresholds for A-F categories, (1,5)
%                                    double vector
%           central_tendency_metric: 0=Mean / 1=Median / 2=Percentile
%           percentile:              mandatory when selectinc central
%                                    tendency metric = 2.
%
% Outputs:  acc: accuracy of graininess categorization based on the
%                proposed thresholds and responses from psychophysical
%                experiments.
%
% Examples:
%   acc = evaluate_categorization_accuracy(SCG_320Chart)
%   acc = evaluate_categorization_accuracy(SCG_320Chart,[0.45,0.9,1.35,1.8,2.25],2,85)
%   acc = evaluate_categorization_accuracy(SCG_MediaWedge,[0.3,0.45,0.6,0.9,1.2],1)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: categorization_exp_results.mat
%
% By: 
% Doménica Alejandra Merchán García
% 01-07-2024; last modified: 13-07-2024 
%--------------------------------------------------------------------------
arguments
    metric_scores           (:,:) double
    thresholds              (1,5) double = [0.45,0.9,1.35,1.8,2.25]
    central_tendency_metric (1,1) double = 0
    percentile              (1,1) double = 0
end

categorization_exp_results = struct2cell(load("../variables/categorization_exp_results.mat"));
categorization_exp_results = categorization_exp_results{1};
samples = size(metric_scores,2);
if samples ~= 30
    errordlg("30 samples expected");
end
names = [' 0 /  0';' 1 /  1';' 1 /  5';' 1 / 10';' 2 / 10';' 2 / 15';
    ' 2 / 20';' 3 / 15';' 4 / 25';' 5 / 10';' 5 / 15';' 7 / 20';' 7 / 30';
    ' 8 / 15';' 8 / 30';' 8 / 50';' 8 / 75';' 9 / 25';' 9 / 50';' 9 / 75';
    '10 / 10';'10 / 30';'10 / 50';'11 / 50';'12 / 50';'13 / 50';'14 / 50';
    '15 / 50';'16 / 50';'16 /100';];

if central_tendency_metric == 0 
    tle = "SCG Score calculated with the Mean of patch scores";
    scg = mean(metric_scores);
elseif central_tendency_metric == 1
    tle = "SCG Score calculated with the Q2 (Median) of patch scores";
    scg = median(metric_scores);
elseif central_tendency_metric == 2
    tle = "SCG Score calculated with the "+percentile+"th Percentile of patch scores";
    scg = prctile(metric_scores,percentile);
else
    errordlg("Invalid central tendency metric, choose 0 for Mean, 1 for Median, or 2 for Percentile");
end

metric_cat = strings(1,length(scg));
for i = 1:length(scg)
    if scg(i) <= thresholds(1); metric_cat(i) = "A";
    elseif scg(i) <= thresholds(2); metric_cat(i) = "B";
    elseif scg(i) <= thresholds(3); metric_cat(i) = "C";
    elseif scg(i) <= thresholds(4); metric_cat(i) = "D";
    elseif scg(i) <= thresholds(5); metric_cat(i) = "E";
    else; metric_cat(i) = "F"; 
    end
end
acc = sum(categorization_exp_results == metric_cat)/samples;

f = figure;
f.Position = [100 100 875 525];

x = scg(categorization_exp_results == metric_cat)';
y = 1:samples;
scatter(x,y(categorization_exp_results == metric_cat),[],[0 0.4470 0.7410],'filled');
hold on
x = scg(categorization_exp_results ~= metric_cat)';
scatter(x,y(categorization_exp_results ~= metric_cat),[],[0 0.4470 0.7410]);

yticks(1:1:samples)
yticklabels(names)
ylabel("Intensity/Frequency sythetic graininess");
xlabel("S_C_G");
title(tle);
subtitle("Accuracy: "+acc);
xline([0 thresholds], '--', {'A','B','C','D','E','F'})
xticks([0 thresholds])
ylim([0 samples+1])
grid()
legend('SCG Correct Category', 'SCG Incorrect Category','Thresholds');
legend("Location","southeast");