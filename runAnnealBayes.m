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

for t = 1:T
    disp(['cur t:' num2str(t) '     out of    ' num2str(T)]);
    for j = 1:J
        load(files{(t-1)*J+j});
        for k=1:length(erdosPs)
            [covMat bestLP] = simAnnealErdos(@erdosPost,data,numOptRuns,erdosPs(k),.4);
            bayesSigs{k,j}(:,:,t) = reshape(covMat, [ N N 1]);
            tBDists(k,j,t) = covMatDist(reshape(bayesSigs{k,j}(:,:,t), [N N]), ...
                                        reshape(trueSigs{j}(:,:,t), [N N]));
        end
        if runWish
            [covMat bestLP] = simAnneal(@wishPost,data,numOptRuns,b,10*eye(N));
            bayesSigs{length(erdosPs)+1,j}(:,:,t) = reshape(covMat, [N N 1]);
            
            tBDists(length(erdosPs)+1,j,t) = covMatDist(reshape(bayesSigs{length(erdosPs)+1,j}(:,:,t), [N N]), ...
                                        reshape(trueSigs{j}(:,:,t), [N N]));
        end
    end
end


end

