function [ files ] = getFileList(baseDir,T,ktChs, erdosPs, runWish)
%GETFILELIST Summary of this function goes here
%   Detailed explanation goes here

b = [pwd baseDir];
J = sum(ktChs) + length(erdosPs)+runWish;
files = cell(T*J,1);
for t = 1:T
    curIt = 1;
    if ktChs(1)
        files{(t-1)*J+curIt} = [b genRandPartSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    if ktChs(2)
        files{(t-1)*J+curIt} = [b genRandChainSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    if ktChs(3)
        files{(t-1)*J+curIt} = [b genRandTreeSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    
    if ktChs(4)
        files{(t-1)*J+curIt} = [b genRandGridSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    
    for jEps = 1:length(erdosPs)
        files{(t-1)*J+curIt} = [b genRandErdosSig(-1,erdosPs(jEps)) num2str(t)];
        curIt = curIt+1;
    end
    
    if runWish
        files{(t-1)*J+curIt} = [b genRandWishSig(-1) num2str(t)];
    end
end

end

