function [treeN latentN leafN] = genRandTree(K)
%GENRANDTREE helper function that generates a random, valid, tree topology
%with floor(K/2) "inner" nodes and floor(K/2)+1 "cluster" nodes as leaves
% NOTE: K MUST BE ODD AND > 1

if ((mod(K,2) == 0) || (K <= 1))
    error('For a tree, number of nodes is K > 1 and K must be odd.');
end

%start tree with root and 2 leaves
treeN = {[2 3],[],[]};
latentN = [1];
leafN = [2 3];

curNumN = length(latentN)+length(leafN);

while curNumN < K
    %split a random leaf node 
    splitInd = floor(1+length(leafN)*rand);
    
    splitN = leafN(splitInd);
    %move split node, make new leaves, and update tree
    %(splits can only happen at leaves...)
    latentN = [latentN; splitN];
    leafN = [leafN(1:(splitInd-1)); leafN((splitInd+1):end); ...
            (curNumN+1); (curNumN+2)];
    treeN{splitN} = [(curNumN+1) (curNumN+2)];
    treeN = {treeN{:}, [], []};
    curNumN = length(latentN) + length(leafN);
end