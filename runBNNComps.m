function [bestBDists nnBestBSigs bestTDists nnBestTSigs bestInds] = runBNNComps(dirName,T,bayesSigs,trueSigs,ktChs,erdosPs,runWish,nnFun,nnCompFun,l_rate,maxEpochs,sigSig)
%RUNBNNCOMPS
if nargin < 8
    nnFun = @runNN;
end
if nargin < 9
    nnCompFun = @bestNNVars;
end

if nargin < 10
    l_rate = 2.5e-3;
end

if nargin < 11
    maxEpochs = 2e3;
end

if nargin < 12
    sigSig = 1;
end
I = size(bayesSigs,1);
J = size(bayesSigs,2);

bestBDists = zeros(I,J,T);
bestTDists = zeros(J,T);
nnBestBSigs = cell(I,J);
nnBestTSigs = cell(J);
files = getFileList(dirName,T,ktChs,erdosPs,runWish);
load(files{1});
N = objcount;
clear objcount data;


for j = 1:J
    for i = 1:I
        nnBestBSigs{i,j} = zeros(N,N,T);
    end
    nnBestTSigs{j} = zeros(N,N,T);
end

for t = 1:T
    disp(['cur t:' num2str(t) '     out of    ' num2str(T)]);
    for j = 1:J
        load(files{(t-1)*J+j});
        [Ys Zs] = nnFun(data,l_rate,maxEpochs);
        for i = 1:I
            bestBDist = Inf;
            while isinf(bestBDist)
              [bestInd bestBDist bestSig] = nnCompFun(Ys,Zs,sigSig, reshape(bayesSigs{i,j}(:,:,t),[N N]));
              if isinf(bestBDist)
                  disp('bestBDist is inf');
              end
            
            end
            bestBDists(i,j,t) = bestBDist;
            nnBestBSigs{i,j}(:,:,t) = reshape(bestSig, [N N 1]);
        end

        [bestInd bestTDist bestSig] = nnCompFun(Ys,Zs,sigSig, reshape(trueSigs{j}(:,:,t),[N N]));
        disp(bestInds);
        bestTDists(j,t) = bestTDist;
        nnBestTSigs{j}(:,:,t) = reshape(bestSig, [N N 1]);
    end
end
end
