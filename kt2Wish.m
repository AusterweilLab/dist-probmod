function [ bayesSigs tKTDists ] = kt2Wish(T,trueSigs,structs,ktChs,erdosPs,runWish)
%KTWISH2 converts the structure found by charles' code into covariances
% tKTDists is the distance of trueSigs to KTsigs
J = sum(ktChs)+length(erdosPs)+runWish;
bayesSigs = cell(sum(ktChs),J);
% tKTDists = zeros(size(bayesSigs));

allDists = zeros(sum(ktChs),J,T);

N = structs{1,1}.objcount;
ktInds = zeros(J,T);
rInds = setdiff([1 2 6 7] .* ktChs,0);
for j = 1:J
    ktInds(j,:) = genSameTypeInds(j,T,J);
end

sigSig = 5;

for t = 1:T
    for j = 1:J
        for k = 1:length(rInds)
            rInd = rInds(k);
            if t == 1
                for j = 1:J
                    bayesSigs{k,j} = zeros(N,N,T);
                end
            end
            
            bayesSigs{k,j}(:,:,t) = reshape(wToSig(structs{rInd,ktInds(j,t)}.W,sigSig,N), [N N 1]);
            allDists(k,j,t) = covMatDist(reshape(bayesSigs{k,j}(:,:,t), [N N]), ...
                                         reshape(trueSigs{j}(:,:,t), [N N]));
        end
    end
end

tKTDists = allDists;


end

