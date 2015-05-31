function [avgLogP sampCovs] = setUpKTRuns2(sigPr,a,b,T,N,M,dirName,sigCov,its)
%% written by joe austerweil 2012 for comparing the inductive bias of NN
%  and graph priors over Gaussian process.
%  returns avg. log marg. prob. using sigPr

% T = 1e5;
% N = 10;

% a = 2*N;
% b = 1.5*N;



% b=1000;
% sigPr = @(x)genRandWishSig(x,a, eye(N));


% sigCov = 1;
% sigCov = 1/1350;

if nargin < 5
    T = 100;
%     M = 100;
    N = 10;
    a = 1000;
    b = 1000;
end

if nargin < 6
    M = 100;
end

if nargin < 7
    curTime = cputime;
    dirName = ['/runAt' num2str(curTime) '/'];
    mkdir([pwd dirName]);
end
if nargin < 8
    sigCov = 1/1250;
end
if nargin < 9
    its = 101;
end
sigPrParam = sigCov*eye(N);
% muPr = zeros(1,N);
thet = exp(-3);
bet = 0.4;

mkdir([pwd dirName]);
sampCovsIts = cell(its,1);
XsIts = cell(its,1);
logPs = zeros(its,1);
avgLogPs = zeros(its,1);
muPrs = cell(its,1);

objcount = N;

for it = 1:its
    if (mod(it,10) == 0)
            disp(['cur t:' num2str(it) '     out of    ' num2str(its)]);
    end
           
    sampCovs = zeros(N,N,T);
    Xs = zeros(N,M,T);
   
    % [curSig DI] = wishrnd(sigPrParam, a);
    
    args = [thet bet sigCov N];
    
    muPr = zeros(N,1);
    
    for t = 1:T
        curSig = sigPr(args);
        sampCovs(:,:,t) = curSig;
        data = mvnrnd(muPr,curSig,M)';
        Xs(:,:,t) = data;
        %     save([pwd dirName sigPr(-1) num2str(t)], 'data', 'objcount');
    end
    
    logP = wishartinessLP(sampCovs, a,b,sigPrParam);
    avgLogP = logP/T;
    
    muPrs{it} = muPr;
    sampCovsIts{it} = sampCovs;
    XsIts{it} = Xs;
    logPs(it) = logP;
    avgLogPs(it) = avgLogP;
end

% hist(avgLogPs); uncomment to see wishartiness distirbution
ind = find(avgLogPs == median(avgLogPs));

for t = 1:T
%     curSig = sampCovIts{ind}(:,:,t);
    data = XsIts{it}(:,:,t);
    save([pwd dirName sigPr(-1) num2str(t)], 'data', 'objcount');
end

sampCovs = sampCovsIts{it};
Xs = XsIts{it};
avgLogP = median(avgLogPs);
logPs = median(logPs);

clear sampCovsIts;
clear XsIts;

save([pwd dirName sigPr(-1) 'allData']);
