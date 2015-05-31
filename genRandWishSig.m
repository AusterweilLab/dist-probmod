function [ sigImp] = genRandWishSig(args, a, DI)
%GENRANDWISHSIG Summary of this function goes here
%   Detailed explanation goes here
if ((length(args) == 1) && (args == -1)) 
    sigImp = 'wishDistRun';
    return;
end

if length(args) ~= 4
    error('covariance generators should be given a vector of arguments of length 4');
end

if nargin <= 1
    a = 5*N;
end

thet = args(1);
bet = args(2);
sigSig = args(3);
N = args(4);

if nargin <= 2
    %make faster by passing in DI as optional third arg.
    sigImp = wishrnd(sigSig*eye(N),a);
elseif nargin == 3
    sigImp = wishrnd(sigSig*eye(N),a,DI);
else
    sigImp  = [];
    error('wrong number of arguments to the wishart covariance generator');
end

