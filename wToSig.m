function [ sigMat] = wToSig( W, sigSig,N)
%WTOSIG Converts W found by charles' code to the covariance matrix of the
%GP for bayesnn simulations. sigSig is the regularization parameter

if nargin <= 2
   N = size(W,1); 
end

%make W symmetric as this isn't directed...
W = W+W';

X = (diag(sum(W,2)) - W + sigSig * eye(size(W)))^(-1);
sigMat = X(1:N,1:N);


end