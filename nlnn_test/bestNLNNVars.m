function [bestInd bestErr bestSig] = bestNLNNVars(Ys,Zs, sigSig, bayesSig)
%BESTNLNNVARS

bestErr = Inf;
bestInd = -1;
bestSig = zeros(size(bayesSig));

for t=1:length(Ys)
    Y = Ys{t};

    curSig = sigSig * Y*Y';
    curErr = covMatDist(curSig,bayesSig);
    if curErr < bestErr
        bestInd = t;
        bestSig = curSig;
        bestErr = curErr;
    end
end
