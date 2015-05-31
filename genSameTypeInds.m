function [ inds ] = genSameTypeInds( off, T, numTypes )
%GENSAMETYPEINDS 

if nargin <= 2
   numTypes = 4; 
end
inds = off:numTypes:(T*numTypes);

end

