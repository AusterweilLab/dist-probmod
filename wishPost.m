function [val] = wishPost( covMat,X,B,covInv,b,psiInv)
%WISHPOST log posterior prob. (unnormalized) of covariance matrix for some  
%       data under a wishart model

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
    b = 1000;
end

if nargin < 6
    psiInv = eye(N);
end
    

val = (1/2)*(b - N*(M+1)-1) *logdet(covMat) - (1/2) * trace(psiInv*covMat) ...
    - (1/2) * trace(B * covInv);

end

