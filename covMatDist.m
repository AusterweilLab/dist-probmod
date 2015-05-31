function [ matDist ] = covMatDist(A,B)
%COVMATDIST Calculates distance between two positive definite matrices
%(covariance matrices)

%calculates generalized eigenvectors
d = eig(A,B);

matDist = sum(log(d).^2);

end

