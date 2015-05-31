function [ val] = erdosPost(covMat,X,B,covInv,p,bet,Scur)
%ERDOSPOST log posterior prob. (unnormalized) of covariance matrix for some  
%       data under an erdos model

N = size(covMat,1);
M = size(X,2);

if nargin < 3
        B = zeros(N,N);    
    for m=1:M
        B = B + X(:,m)*X(:,m)';
    end
end

if nargin < 4
    covInv = covMat^(-1);
end

if nargin < 5
    p = 0.5;
end

if nargin < 6
    bet = 0.4;    
end

val = 0;
epsVal = 1e-4;

%prior influence
for i = 1:N
    for j = 1:(i-1)
        if (abs(Scur(i,j)) < epsVal)
            val = val + log(1-p);
        else
            val = val + log(p) + log(exppdf(1/Scur(i,j), bet));
        end
    end
end

%likelihood influence
val = val - (M/2)*logdet(covMat) - (1/2) * trace(B*covInv);
% val = val  - (1/2) * trace(B*covInv);
end

