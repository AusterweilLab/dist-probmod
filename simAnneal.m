function [covMat bestLP] = simAnneal(funEval, X, its,b, psiMat)
%SIMANNEAL 

GRAPHICS = 0;

Kanneal = 200;
N = size(X,1);
M = size(X,2);
B = zeros(N,N);

if nargin < 4
    b = 1000;
end

if nargin < 5
    psiMat = eye(N); 
end

for m=1:M
    B = B + X(:,m)*X(:,m)';
end

psiInv = psiMat^(-1);

B = B/(M-1);

trackLPs = zeros(its,1);

covMat = iwishrnd(psiMat+B,b+N);
covInv = covMat^(-1);
bestLP = funEval(covMat,X,B,covInv,b,psiInv);
[temp Dcur] = wishrnd(covMat,b+N);

trackLPs(1) = bestLP;
numApp = 0;

for it = 2:its
    curT = log(it+1)/Kanneal;
    
    [propMat Dprop] = wishrnd(covMat,b+N,Dcur);
    toPropLP = mywishpdfln(propMat,b+N,covMat);
    fromPropLP = mywishpdfln(covMat,b+N,propMat);

    propInv = propMat^(-1);
    
    propLP = funEval(propMat,X,B,propInv,b,psiInv);
    
    pSwap = 1/(1+exp(-curT*(propLP + toPropLP - fromPropLP - bestLP)));
    
    if (rand < pSwap)
        bestLP = propLP;
        covMat = propMat;
        Dcur = Dprop;
        numApp = numApp+1;
        %covInv = propInv;
    end
    trackLPs(it) = bestLP;
    
end
disp(['number of acceptances: ' num2str(numApp)]);
if GRAPHICS
    plot(trackLPs(10:end))
end
end

