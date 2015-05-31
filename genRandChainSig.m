function [sigImp] = genRandChainSig(args)
%GENRANDCHAIN generate covariance matrix implied by a random chain 
%   where args contains in order:
%   and the number of latent variables is Geo(thet) 
%   and edge lengths are drawn Exp(bet)
%   sigSig is the variance parameter for regularizing the graph laplacian
%   N is the number of objects
%   returns the sigImp (sigma implied by the random chain)

if ((length(args) == 1) && (args == -1)) 
    sigImp = 'chainDistRun';
    return;
end

%K must be between 1 and N

if length(args) ~= 4
    error('covariance generators should be given a vector of arguments of length 4');
end

thet = args(1);
bet = args(2);
sigSig = args(3);
N = args(4);

K = 0;
while ((K <= 0) || (K>N))
    K = geornd(thet);
end

%all chains with same number of nodes, but before lengths and variables are
%assigned to edges and nodes (respectively) are equivalent. thus, draw
%assignments of variables to nodes, lengths, 
varsAss = floor(1+K*rand(N,1));

S = zeros(K+N,K+N);

%now draw edge lengths for all nodes in the cluster graph connected by an edge. 
%as this is a chain. it's just the upper diagonal of a matrix (1->2,2->3,(N-1)->N)
%then we connect the real variables to these latent nodes and draw edge
%lengths for them

for k=1:(K-1)
    S(k,k+1) = 1/exprnd(bet);
    S(k+1,k) = S(k,k+1);
end

for i = 1:length(varsAss)
    S(i+K,varsAss(i)) = 1/exprnd(bet);
    S(varsAss(i),i+K) = S(i+K,varsAss(i));
end

%now finish up with sigImp = (G-S+(1/sigSig^2)I)^(-1)
G = diag(sum(S,2));

sigImpFull = (G-S+(1/sigSig)*eye(K+N))^(-1);

sigImp = sigImpFull((K+1):(K+N),(K+1):(K+N));
end