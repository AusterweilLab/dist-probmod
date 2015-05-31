function [ sigImp ] = genRandGridSig( args )
%GENRANDGRIDSIG generate covariance matrix implied by a random grid
%   where args contains in order:
%   and the number of latent variables is Geo(thet) 
%   and edge lengths are drawn Exp(bet)
%   sigSig is the variance parameter for regularizing the graph laplacian
%   N is the number of objects
%   returns the sigImp (sigma implied by the random grid)

if ((length(args) == 1) && (args == -1)) 
    sigImp = 'gridDistRun';
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

%set up grid from random 2 divisors

divs = divisor(K);
divsH = divs(find(divs <= sqrt(K)));

wInd = floor(1+length(divsH)*rand);
w = divsH(wInd);
h = K/w;

goodAss = 0;
varsAss = zeros(N,1);

while (goodAss == 0)
    %assign nodes to random points on grid.
    varsAss = floor(1+K*rand(N,1));
    %make sure there's atleast one object assigned to each dim value.
    %check cols
    colsOk = zeros(w,1);
    rowsOk = zeros(h,1);
    for i = 1:w
        colInds = i:w:K;
        for j = 1:length(colInds)
            colsOk(i) = colsOk(i) || (~isempty(find(varsAss == colInds(j))));
        end
    end
    
    for i = 1:h
        rowInds = (1+(i-1)*w):(i*w);
        for j = 1:length(rowInds)
            rowsOk(i) = rowsOk(i) || (~isempty(find(varsAss == rowInds(j))));
        end
    end
    goodAss = prod(colsOk) * prod(rowsOk);
end

%build latent grid.
S = zeros(K+N,K+N);
%build row links.
for row = 1:h
    for col = 1:(w-1)
        S(col+(row-1)*w, col+(row-1)*w+1) = 1/exprnd(bet);
        S(col+(row-1)*w+1,col+(row-1)*w) = S(col+(row-1)*w, col+(row-1)*w+1);
    end
end
%build col links
for col = 1:w
    for row = 1:(h-1)
        S(col+(row-1)*w,col+row*w) = 1/exprnd(bet);
        S(col+row*w,col+(row-1)*w) = S(col+(row-1)*w,col+row*w);
    end
end
%assign entity nodes and finish up
for i = 1:length(varsAss)
    S(i+K,varsAss(i)) = 1/exprnd(bet);
    S(varsAss(i),i+K) = S(i+K,varsAss(i));
end

%now finish up with sigImp = (G-S+(1/sigSig^2)I)^(-1)
G = diag(sum(S,2));

sigImpFull = (G-S+(1/sigSig)*eye(K+N))^(-1);

sigImp = sigImpFull((K+1):(K+N),(K+1):(K+N));

end

