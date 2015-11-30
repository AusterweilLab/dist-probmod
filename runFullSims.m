%% written by joe austerweil as part of the bayesNN project
%full runs take 4 or more days to run, so i suggest running them on a
%server
global nautyInstalled;

%% NEED TO SET
%this part sets parameters that determine the current runs of

dirName = '/mydir/'; %where to save data files (usually about 15MB)
resFileName = 'may12Runs'; %where to save results (makes intermediate saves)
latFileName = 'may12TabRes.tex'; %where to save table of results

%kemp & tenenbaum (2008) discrete priors
%set to 1 to include it in the simulation
%(right now, partition, chain, tree, and grid are supported,
%though many more are implemented in charles kemp's code).

runPart = 1;
runChain = 1;
runTree = 1;
runGrid = 1;

%erdosPriors (ps to run)
erdosPs = [.1 .5 .9];

%wishart prior
runWish = 1;

%% OPTIONAL to change (set to params. used in 2012 cogsci proc.
%(except wishart normed to have approx. = norm to others
numOptRuns = 5e4; % i think this can probably be smaller...
% numOptRuns = 1e3;
l_rate = 5e-3; % was 2.5e-5
maxEpochs = 5e3; % was 3e3


a = 1000;
b = 1000;
N = 10;
T = 100;
M = 100;
its = 101; %# of iterations for calculating median of lpWish
sigCov = 1/300;
mkdir([pwd dirName]);
sigPrParam = sigCov*eye(N);
thet = exp(-3);
bet = 0.4;
nautyInstalled = 1; %best if it is, but if not, set to 0 (charles' code will be slower).

%variable containing the function implementing a neural network learning
%algorithm
nnFun = @runNN; %standard linear NN grad descent
%variable containing the function that finds the  NN covariance
%matrix "closest" to another covariance matrix
nnCompFun = @bestNNVars; %YY' conversion

J = runPart + runChain + runTree + runGrid + length(erdosPs) + runWish;
I = J;

% path of charles' code (only needed if it is not in your path already.
% also need to change directory if charles' code does not live there).
addpath(strcat(pwd, '/formdiscovery1.0/'));


disp(['------------ making data sets in ''' dirName '''--------------']);
%% sets up runs. makes dataset with median wishartiness and returns
% wishartiness
lpWishs = zeros(J,1);
trueSigs = cell(J,1);
curIt = 1;
prNames = cell(J,1);
save(resFileName);
if runPart
    disp(['------------------- Running ' genRandPartSig(-1) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@genRandPartSig,a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt) = curWishLP;
    trueSigs{curIt} = sampCovs;
    prNames{curIt} = genRandPartSig(-1);
    curIt = curIt+1;
end
if runChain
        disp(['------------------- Running ' genRandChainSig(-1) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@genRandChainSig,a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt) = curWishLP;
    trueSigs{curIt} = sampCovs;
    prNames{curIt} = genRandChainSig(-1);
    curIt = curIt+1;
end
if runTree
    disp(['------------------- Running ' genRandTreeSig(-1) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@genRandTreeSig,a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt) = curWishLP;
    trueSigs{curIt} = sampCovs;
    prNames{curIt} = genRandTreeSig(-1);
    curIt = curIt+1;
end
if runGrid
    disp(['------------------- Running ' genRandGridSig(-1) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@genRandGridSig,a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt) = curWishLP;
    trueSigs{curIt} = sampCovs;
    prNames{curIt} = genRandGridSig(-1);
    curIt = curIt+1;
end

for j = 1:length(erdosPs)
    disp(['------------------- Running ' genRandErdosSig(-1,erdosPs(j)) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@(x)genRandErdosSig(x,erdosPs(j)), ...
                                        a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt+j-1) = curWishLP;
    trueSigs{curIt+j-1} = sampCovs;
    prNames{curIt+j-1} = genRandErdosSig(-1,erdosPs(j));
end
curIt = curIt+length(erdosPs);
if runWish
    disp(['------------------- Running ' genRandWishSig(-1,a) ' ------------------']);
    [curWishLP sampCovs] = setUpKTRuns2(@(x)genRandWishSig(x,a),a,b,T,N,M,dirName,sigCov,its);
    lpWishs(curIt) = curWishLP;
    trueSigs{curIt} = sampCovs;
    prNames{curIt} = genRandWishSig(-1,a);
end
save(resFileName);
disp('-----------------data sets made---------------');
disp('-----------------Starting Bayesian inference---------------');
%% run bayes inference
ktChs = [runPart runChain runTree runGrid];
tKT1Dists = [];
if sum(ktChs) > 0
    ps = setmyps(dirName,T,M, ktChs, erdosPs,runWish);
    disp('------------------starting Charles Kemp''s Code------------------');
    structs = runKT(dirName,T,M,ps,ktChs);
    disp('------------------Charles Kemp''s Code finished------------------');
    save(resFileName);
    disp('------------------Converting Kemp format to Sigs-------------------');
    [ bayesSigs1 tKT1Dists ] = kt2Wish(T,trueSigs,structs,ktChs,erdosPs,runWish);
    save(resFileName);
    disp('------------------Done converting Kemp format-------------------');
else
    disp('----------skipping Charles Kemp''s Code---------------------');
end
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
[bestBDists nnBestBSigs bestTDists nnBestTSigs bestInds] = runBNNComps(dirName,T,bayesSigs,trueSigs, ...
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
scatter(lpWishs, meanBDists, [], linspace(1,10,length(meanBDists)));
labels = {'Part','Chain','Tree','Grid','erdosPs1','erdosPs2','erdosPs3','Wishart'}; dx = -0.4; dy = -0.4;
text(lpWishs+dx,meanBDists+dy, labels)
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
