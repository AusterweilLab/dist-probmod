function [sigImp] = genRandPartSig( args )
%GENRANDPARTSIG generate covariance matrix implied by a random partition 
%   where args contains in order:
%   and the number of latent variables is Geo(thet) 
%   and edge lengths are drawn Exp(bet)
%   sigSig is the variance parameter for regularizing the graph laplacian
%   N is the number of objects
%   returns the sigImp (sigma implied by the random partition)

if ((length(args) == 1) && (args == -1)) 
    sigImp = 'partDistRun';
    return;
end


if length(args) ~= 4
    error('covariance generators should be given a vector of arguments of length 4');
end

thet = args(1);
bet = args(2);
sigSig = args(3);
N = args(4);

%K must be between 1 and N

K = 0;
while ((K <= 0) || (K>N))
    K = geornd(thet);
end

%all partitions with the same number of latent nodes are equiv. (latent
%nodes are the blocks). Thus, assign vars. to latent nodes and then draw
%the edge lengths

varsAss = floor(1+K*rand(N,1));

S = zeros(K+N,K+N);

for i = 1:length(varsAss)
    S(i+K,varsAss(i)) = 1/exprnd(bet);
    S(varsAss(i),i+K) = S(i+K,varsAss(i));
end

%now finish up with sigImp = (G-S+(1/sigSig^2)I)^(-1)
G = diag(sum(S,2));

sigImpFull = (G-S+(1/sigSig)*eye(K+N))^(-1);

sigImp = sigImpFull((K+1):(K+N),(K+1):(K+N));

end

