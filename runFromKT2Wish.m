load('may12Runs.mat');
ps = setmyps(dirName,T,M, ktChs, erdosPs,runWish);
disp('------------------starting Charles Kemp''s Code------------------');
structs = runKT(dirName,T,M,ps,ktChs);
disp('------------------Charles Kemp''s Code finished------------------');
save(resFileName);
disp('------------------Converting Kemp format to Sigs-------------------');
[ bayesSigs1 tKT1Dists ] = kt2Wish(T,trueSigs,structs,ktChs,erdosPs,runWish);
save(resFileName);
disp('------------------Done converting Kemp format-------------------');
disp('------------------Starting annealing runs (non-KT priors)-------------------');
[bayesSigs2 tB2Dists] = runAnnealBayes(dirName,T,trueSigs,ktChs,erdosPs,runWish,b,numOptRuns);
disp('------------------Done running (non-KT priors)-------------------');
save(resFileName);

bayesSigs = cell(J,J);
for j=1:J
    curIt = 1;
    for i = 1:sum(ktChs)
        if ktChs(i)
            bayesSigs{curIt,j} = bayesSigs1{curIt,j};
            curIt = curIt+1;
        end
    end

    for i = 1:length(erdosPs)
        bayesSigs{i+sum(ktChs),j} = bayesSigs2{i,j};
    end
    if runWish
        bayesSigs{sum(ktChs)+length(erdosPs)+1,j} = bayesSigs2{length(erdosPs)+1,j};
    end
end
tBDists = [tKT1Dists tB2Dists];
%% starting NN comparisions
disp('------------------Starting Bayes-NN comparisons-------------------');
[bestBDists nnBestBSigs bestTDists nnBestTSigs] = runBNNComps(dirName,T,bayesSigs,trueSigs, ...
                                                              ktChs,erdosPs,runWish,nnFun, ...
                                                              nnCompFun,l_rate,maxEpochs);

disp('------------------Done Bayes-NN comparisons-------------------');
save(resFileName);
%% analyses

disp('------------------Starting analyses-------------------');
disp('------------------Wishartiness-Bayes-NN dist analyses-------------------');
meanBDists = mean(mean(bestBDists,3),2);
meanTDists = mean(bestTDists,2);
bNNCorPearson = corr(meanBDists, lpWishs);
bNNCorSpearman = corr(meanBDists,lpWishs, 'type', 'Spearman');
bNNCorKendall = corr(meanBDists,lpWishs, 'type', 'Kendall');

disp(['Pearson correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorPearson)]);
disp(['Spearman correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorSpearman)]);
disp(['Kendall correlation between best Bayes-NN Distance and Wishartiness: ' num2str(bNNCorKendall)]);

disp('---------------------------------------------------------------------');
close all;
figure(1);
scatter(lpWishs, meanBDists);
xlabel('Log Wishart marginal likelihood');
ylabel('Bayes-NN distance');
title('Average distance YY^T from Bayesian estimators with different priors');

[lpWishsSort sortInds] = sort(lpWishs);
prNamesSort = cell(length(prNames),1);

for i = 1:length(sortInds)
    prNamesSort{i} = prNames{sortInds(i)};
end

outMat = [lpWishsSort'; meanBDists(sortInds)'; meanTDists(sortInds)'];
rowLbls = {'Wishartiness', 'Truth-NN Dist', 'Bayes-NN Dist'};
matrix2latex(outMat,latFileName,'rowLabels', rowLbls, 'columnLabels', prNamesSort);

save(resFileName);
