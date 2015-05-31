function [ sigImp S] = genRandErdosSigWS( args, p )
%GENRANDERDOSSIG generates a random erdos renyi graph. defaults to p = 0.5

if nargin == 1
    p = 0.5;
end

if ( (length(args)==1) && (args == -1))
    sigImp = ['p' num2str(10*p) 'erdosDistRun' ];
    return;
end


if length(args) ~= 4
    error('covariance generators should be given a vector of arguments of length 4');
end

thet = args(1);
bet = args(2);
sigSig = args(3);
N = args(4);

S = zeros(N,N);

%no self loops, undirected random graph.
for i = 1:N
    for j = 1:(i-1) 
        if rand < p
            S(i,j) = 1/exprnd(bet);
            S(j,i) = S(i,j);
        end
    end
end

%now finish up with sigImp = (G-S+(1/sigSig^2)I)^(-1)
G = diag(sum(S,2));

sigImp = (G-S+(1/sigSig)*eye(N))^(-1);
