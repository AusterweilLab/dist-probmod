function [propMat newS] = erdosProp2( curMat, p, bet,curMatInv, S)
%ERDOSPROP generates an erdos matrix proposal centered at curMat, where p
%is the prob. of an edge (default p = 0.5) & bet is param for edge lengths
%(default = .4)

if nargin <2
    p = .5;
end

if nargin < 3
    bet = .4;
end

if nargin < 4
    curMatInv = curMat;
end
N = size(curMat,1);
%
% S = zeros(N,N);
%
% for i = 1:N
%     for j = 1:(i-1)
%         S(i,j) = curMatInv(i,j);
%         S(j,i) = S(i,j);
%     end
% end



D = diag(sum(S,2));

% noiseDiag = diag(diag(curMatInv)+diag(D));
noiseDiag = eye(N) + D;
newS = S;

epsVal = 1e-4;

%get edges
[rowsE colsE] = find(abs(S) > epsVal);
[rowsNoE colsNoE] = find(abs(S) < epsVal);
rowNoDE = [];
colNoDE = [];
rowNoDNoE = [];
colNoDNoE = [];

for i = 1:length(rowsE)
    if (rowsE(i) < colsE(i))
        rowNoDE = [rowNoDE; rowsE(i)];
        colNoDE = [colNoDE; colsE(i)];
    end
end

for i = 1:length(rowsNoE)
    if (rowsNoE(i) < colsNoE(i))
        rowNoDNoE = [rowNoDNoE; rowsNoE(i)];
        colNoDNoE = [colNoDNoE; colsNoE(i)];
    end
    
end

N = size(curMat,1);

curNumE = length(rowNoDE);

propNumE = binornd(N*(N-1)/2,p);

if propNumE < curNumE
    for i = propNumE:(curNumE-1)
        
        %remove edge
        if (~isempty(rowNoDE))
            newInd = floor(1+length(rowNoDE)*rand);
            newR = rowNoDE(newInd);
            newC = colNoDE(newInd);
            newS(newR,newC) = 0;
            newS(newC,newR) = 0;
            
            rowNoDNoE = [rowNoDNoE; newR];
            colNoDNoE = [colNoDNoE; newC];
            rowNoDE = rowNoDE([1:(newInd-1) (newInd+1):length(rowNoDE)]);
            colNoDE = colNoDE([1:(newInd-1) (newInd+1):length(colNoDE)]);
            
            
        end
    end
else
    for i = curNumE:(propNumE-1)
        %create edge if possible, otherwise return same matrix
        if (~isempty(rowNoDNoE))
            newInd = floor(1+length(rowNoDNoE)*rand);
            newR = rowNoDNoE(newInd);
            newC = colNoDNoE(newInd);
            newS(newR,newC) = 1/exprnd(bet);
            newS(newC,newR) = newS(newR,newC);
            
            rowNoDNoE = rowNoDNoE([1:(newInd-1) (newInd+1):length(rowNoDNoE)]);
            colNoDNoE = colNoDNoE([1:(newInd-1) (newInd+1):length(colNoDNoE)]);
            rowNoDE = [rowNoDE; newR];
            colNoDE = [colNoDE; newC];
        end
        
    end
end


newG = diag(sum(newS,2));

propMat = (newG - newS + noiseDiag)^(-1);