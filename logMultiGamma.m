function [logval] = logMultiGamma(N,x)
%LOGMULTIGAMMA returns the log of the multivariate gamma function 
%   N = dimensionality, x = argument
logval = N*(N-1)/4 * log(pi);

for j=N:-1:1
% for j=1:N
   logval = logval + gammaln(x+(1-j)/2); 
end

end

