function [ logP ] = wishartinessLP(sigs, a,b,prSig)
%WISHARTINESSLP returns the log probability of a set of covariance matrices
%given they were generated from some unknown wishart distribution
%   assumes sigs is (NxNxT) and returns logProb

N = size(sigs,1);
T = size(sigs,3);

sumSig = sum(sigs,3);

logSigDets = 0;
for t=1:T
   logSigDets = logSigDets + (b-N-1)/2 * log(det(reshape(sigs(:,:,t), [N N]) ));
%    sumSig = sumSig + sigs(:,:,t);
end

numLP = (a/2)*log(det(prSig)) + logSigDets + logMultiGamma(N,(a+b*T)/2);
denLP = (a+b*T)/2*log(det(prSig+sumSig)) + logMultiGamma(N,a/2) ...
      + T*logMultiGamma(N,b/2);

logP = numLP-denLP;

% sumSigInv = zeros(N,N);
% logSigDets = 0;
% for t=1:T
%    sumSigInv = sumSigInv + reshape(sigs(:,:,t), [N N])^(-1);
%    logSigDets = logSigDets + (N+b+1)/2 * log(det(reshape(sigs(:,:,t), [N N])));
% end
% 
% 
% numLP = (N+a+b*T)/2*log(det(prSig^(-1)+sumSigInv)) + logMultiGamma(N,(a+b*T)/2);
% denLP = (a/2)*log(det(prSig)) + logSigDets + logMultiGamma(N,a/2) ...
%       + T*logMultiGamma(N,b/2);
% 
% logP = numLP-denLP;

% end



% sumSig = sum(sigs,3);
%
% 
% 
% end

% sumSig = sum(sigs,3);
% logSigDets = 0;
% for t=1:T
%    logSigDets = logSigDets + (b-N-1)/2 * log(det(reshape(sigs(:,:,t), [N N]) ));
% %    sumSig = sumSig + sigs(:,:,t);
% end
% 
% 
% numLP = (a/2)*log(det(prSig)) + logSigDets + logMultiGamma(N,(a+b+2*T)/2);
% denLP = (a+b+2*T)/2*log(det(prSig+sumSig)) + logMultiGamma(N,a/2) ...
%       + T*logMultiGamma(N,b/2);
% 
% logP = numLP-denLP;
% end
