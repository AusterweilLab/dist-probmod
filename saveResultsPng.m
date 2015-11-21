load('may12Runs.mat');
disp('------------------Starting analyses-------------------');
disp('------------------Wishartiness-Bayes-NN dist analyses-------------------');
meanBDists = mean(mean(bestBDists,3),2);
meanBDists = meanBDists(1:length(meanBDists)-1);
lpWishs = lpWishs(1:length(lpWishs)-1);
meanTDists = mean(bestTDists,2);
bNNCorPearson = corr(meanBDists, lpWishs);
bNNCorSpearman = corr(meanBDists,lpWishs, 'type', 'Spearman');
bNNCorKendall = corr(meanBDists,lpWishs, 'type', 'Kendall');

disp(['Pearson correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorPearson)]);
disp(['Spearman correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorSpearman)]);
disp(['Kendall correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorKendall)]);

disp('---------------------------------------------------------------------');
close all;
f = figure('Visible', 'Off');
scatter(lpWishs, meanBDists, [], linspace(1,10,length(meanBDists)));
labels = {'Part','Chain','Tree','Grid','erdosPs1','erdosPs2','erdosPs3'}; dx = -0.4; dy = -0.4;
text(lpWishs+dx,meanBDists+dy, labels)
xlabel('Log Wishart marginal likelihood');
ylabel('Bayes-NN distance');
title('Average distance YY^T from Bayesian estimators with different priors');
gitinfo = getGitInfo();
saveas(f, strcat(gitinfo.branch,'-plot.png'));
exit();