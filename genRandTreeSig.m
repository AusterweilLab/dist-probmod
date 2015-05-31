function [ sigImp ] = genRandTreeSig(args)
%GENRANDTREESIG generate covariance matrix implied by a random tree 
%   where there are N observed variables,
%   and the number of latent variables is Geo(thet) 
%   and edge lengths are drawn Exp(bet)
%   returns the sigImp (sigma implied by the random chain)

if ((length(args) == 1) && (args == -1)) 
    sigImp = 'treeDistRun';
    return;
end


if length(args) ~= 4
    error('covariance generators should be given a vector of arguments of length 4');
end

thet = args(1);
bet = args(2);
sigSig = args(3);
N = args(4);

%K must be odd and > 1

K = 0;
while ((K <= 1) || (mod(K,2)==0) || (K > N))
    K = geornd(thet);
end

[treeN latentN leafN] = genRandTree(K);


%assign variables to leaves
numL = length(leafN);
allVs = 1:numL;
varsAss = floor(1+numL*rand(N,1));
varAssOv = intersect(varsAss,allVs);

while length(varAssOv) < numL
    varsAss = floor(1+numL*rand(N,1));
    varAssOv = intersect(varsAss,allVs);
end



S = zeros(K+N,K+N);
%draw edge lengths for tree
for nI = 1:length(treeN)
    curEdges = treeN{nI};
    for j = 1:length(curEdges)
        S(nI, curEdges(j)) = 1/exprnd(bet);
        S(curEdges(j),nI) = S(nI,curEdges(j));
    end
end
%attach entities to appropriate clusters
for i = 1:length(varsAss)
    S(i+K, varsAss(i)) = 1/exprnd(bet);
    S(varsAss(i),i+K) = S(i+K,varsAss(i));
end
%now finish up with sigImp = (G-S+(1/sigSig^2)I)^(-1)
G = diag(sum(S,2));

sigImpFull = (G-S+(1/sigSig)*eye(K+N))^(-1);

sigImp = sigImpFull((K+1):(K+N),(K+1):(K+N));


