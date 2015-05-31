%% checks norms for the true covariance matrices

norm1s = zeros(size(trueSigs,1),size(trueSigs{1},3));
norm2s = zeros(size(trueSigs,1),size(trueSigs{1},3));
normInfs = zeros(size(trueSigs,1),size(trueSigs{1},3));
normFros = zeros(size(trueSigs,1),size(trueSigs{1},3));
ranks = zeros(size(trueSigs,1),size(trueSigs{1},3));

N = size(trueSigs{1},1);


for i = 1:size(trueSigs,1)
        for t = 1:size(trueSigs{1,1},3)
            norm1s(i,t) = norm(reshape(trueSigs{i}(:,:,t), [N N]), 1);
            norm2s(i,t) = norm(reshape(trueSigs{i}(:,:,t), [N N]), 2);
            normInfs(i,t) = norm(reshape(trueSigs{i}(:,:,t), [N N]), inf);
            normFros(i,t) = norm(reshape(trueSigs{i}(:,:,t), [N N]), 'fro');
            ranks(i,t) = rank(reshape(trueSigs{i}(:,:,t), [N N]));
        end
end

meanN1s = mean(norm1s,2);
meanN2s = mean(norm2s,2);
meanInfs = mean(normInfs,2);
meanFros = mean(normFros,2);

% meanN1s = [meanN1s(5); meanN1s(1:4); meanN1s(6:8)];
% meanN2s = [meanN2s(5); meanN2s(1:4); meanN2s(6:8)];
% meanInfs = [meanInfs(5); meanInfs(1:4); meanInfs(6:8)];
% meanFros = [meanFros(5); meanFros(1:4); meanFros(6:8)];