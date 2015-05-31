function [ lp ] = transLPErdos(curS,p,bet,toS)
%TRANSPERDOS returns log prob. of going from curMat to toMat. inverse args
%are optional, but giving them speeds computation

% if nargin < 5
%     curMatInv = curMat^(-1);
% end
% if nargin < 6
%     toMatInv = toMat^(-1);
% end

N = size(curS,1);

epsVal = 1e-4;

[is js] = find(abs(toS-curS)>epsVal);

% if ((length(is) > 2) || (length(js) > 2))
%     disp('WARNING: more than one difference between states');
% end
lp = 0;

if (~isempty(is))
    diffVal = toS(is(1),js(1))-curS(is(1),js(1));
    if (diffVal < 0)
        %removed node
        lp = log(1-p);
    else
        %added node
        lp = log(p) + log(exppdf(1/toS(is(1),js(1)),bet));
    end
    if isinf(lp)
        disp('fdafa');
    end
end

end

