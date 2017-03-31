function [ bayesSigs tBDists ] = runAnnealBayes(dirName,T,trueSigs,ktChs,erdosPs,runWish,b,numOptRuns)
%RUNANNEALBAYES runs erdos and wishart bayes

if nargin < 7
    b = 1000;
end
if nargin < 8
    numOptRuns = 5e4;
end

files = getFileList(dirName,T,ktChs,erdosPs,runWish);
I = length(erdosPs)+runWish;
J = sum(ktChs) + length(erdosPs)+runWish;

sigSig=1;
bayesSigs = cell(I,J);

load(files{1});
N = objcount;
clear objcount data;

tBDists = zeros(I,J,T);
for i = 1:I
    for j = 1:J
        bayesSigs{i,j} = zeros(N,N,T);
    end
end

erdosAnnealRes = cell(I, J, T);
wishAnnealRes = cell(J, T);
matlabpool(4)
parfor t = 1:T
    disp(['cur t:' num2str(t) '     out of    ' num2str(T)]);
    for j = 1:J
        da = load(files{(t-1)*J+j});
        data = da.data;
        dslice = erdosAnnealRes(:,:,t);
        for k=1:length(erdosPs)
            [covMat bestLP] = simAnnealErdos(@erdosPost,data,numOptRuns,erdosPs(k),.4);
            dslice{j,k} = covMat;
            erdosAnnealRes(:,:,t) = dslice;
        end
        if runWish
            [wishCovMat bestLP] = simAnneal(@wishPost,data,numOptRuns,b,10*eye(N));
            wishAnnealRes{j,t} = wishCovMat;
        end
    end
    disp(['t:' num2str(t) ' finished.']);
end
matlabpool close

% add to bayesSigs
disp('processing annealing results...');
for t = 1:T
    for j = 1:J
        for k = 1:length(erdosPs)
            covMat = erdosAnnealRes{k,j,t};
            bayesSigs{k,j}(:,:,t) = reshape(covMat, [ N N 1]);
            tBDists(k,j,t) = covMatDist(reshape(bayesSigs{k,j}(:,:,t), [N N]), ...
                reshape(trueSigs{j}(:,:,t), [N N]));
        end
        if runWish
            wishCovMat = wishAnnealRes{j,t};
            bayesSigs{length(erdosPs)+1,j}(:,:,t) = reshape(wishCovMat, [N N 1]);
            
            tBDists(length(erdosPs)+1,j,t) = covMatDist(reshape(bayesSigs{length(erdosPs)+1,j}(:,:,t), [N N]), ...
                reshape(trueSigs{j}(:,:,t), [N N]));
        end
    end
end
disp('finished processing annealing runs');
