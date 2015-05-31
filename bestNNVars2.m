function [bestInd bestErr bestSig] = bestNNVars2(Zs,Ys, sigSig, bayesSig)
%BESTNNVARS 

bestErr = Inf;
bestInd = -1;
bestSig = zeros(size(bayesSig));

for t=1:length(Ys)
    Y = Ys{t};
    Z = Zs{t};
    
    curSig = sigSig * Y*(Z*Z')*Y';
%     curSig = sigSig * Y*Z*Z'*Y';
    curErr = covMatDist(curSig,bayesSig);
    if curErr < bestErr 
        bestInd = t;
        bestSig = curSig;
        bestErr = curErr;
    end
end

