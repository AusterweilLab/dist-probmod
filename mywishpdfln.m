function lp = mywishpdfln(X,a,B,inverse)
%WISHPDFLN    Logarithm of Wishart probability density function.
%  See WISHPDF for argument description. 
%this is not a prob. as it is missing the multivariate gamma term (which
%can cause blowup issues)

% Written by Tom Minka; Edited by Joe Austerweil
% (c) Microsoft Corporation. All rights reserved.

if nargin < 3
  B = [];
end
if nargin < 4
  inverse = 0;
end

if inverse
  X = inv(X);
end
if isempty(B)
  XB = X;
  logDetB = 0;
else
  XB = X*B;
  logDetB = logdet(B);
end
d = rows(X);
d2 = (d+1)/2;
if inverse
  d2 = -d2;
end
logDetXB = (a-d2)*logdet(XB);
% lp = logDetXB - trace(XB) + d2*logDetB - logMultiGamma(a/2,d);
lp = logDetXB - trace(XB) + d2*logDetB;