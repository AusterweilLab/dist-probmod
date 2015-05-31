function [covMat bestLP] = simAnnealErdos(funEval, X, its,p,bet)
%SIMANNEAL 

GRAPHICS = 0;

Kanneal = 10;


N = size(X,1);
M = size(X,2);
B = zeros(N,N);

if nargin < 4
    b = 1000;
end

if nargin < 5
    p=.5; 
end

if nargin < 6
    bet = 0.4;
end

for m=1:M
    B = B + X(:,m)*X(:,m)';
end

psiMat = eye(N);

psiInv = psiMat^(-1);

B = B/(M-1);

trackLPs = zeros(its,1);

[covMat Scur] = genRandErdosSigWS([1 bet 1 N],p);
covInv = covMat^(-1);
bestLP = funEval(covMat,X,B,covInv,p,bet,Scur);
% [temp Dcur] = wishrnd(covMat,b+N);

trackLPs(1) = bestLP;
numApp = 0;

for it = 2:its
    curT = log(it+1)/Kanneal;
    
%     [propMat Sprop] = erdosProp(covMat,.5,bet,covInv,Scur);
    [propMat Sprop] = erdosProp2(covMat,p,bet,covInv,Scur);
    
%     toPropLP = mywishpdfln(propMat,b+N,covMat);
%     fromPropLP = mywishpdfln(covMat,b+N,propMat);
    toPropLP = transLPErdos(Scur,p,bet,Sprop);
    fromPropLP = transLPErdos(Sprop,p,bet,Scur);
    
    propInv = propMat^(-1);
    
    propLP = funEval(propMat,X,B,propInv,p,bet,Sprop);
    
    expVal = -(propLP + toPropLP - fromPropLP - bestLP)*curT;
    
    pSwap = 1/(1+exp(expVal));
    
    if isinf(expVal)
%         disp('fdafa');
    end
    
    if (rand < pSwap)
        bestLP = propLP;
        covMat = propMat;
        Scur = Sprop;
        numApp = numApp+1;
        %covInv = propInv;
    end
    trackLPs(it) = bestLP;
%     if (mod(it,100) == 0)
%         disp(['it: ' num2str(it) '              curT: ' num2str(curT) ]);
%         disp(['exp: ' num2str(expVal)]);
%     end
end
% disp(['number of acceptances: ' num2str(numApp)]);
% plot(trackLPs(10:end))

end

