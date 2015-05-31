norm1s = zeros(size(bestBSigs,1),size(bestBSigs,2),size(bestBSigs{1,1},3));
norm2s = zeros(size(bestBSigs,1),size(bestBSigs,2),size(bestBSigs{1,1},3));
normInfs = zeros(size(bestBSigs,1),size(bestBSigs,2),size(bestBSigs{1,1},3));
normFros = zeros(size(bestBSigs,1),size(bestBSigs,2),size(bestBSigs{1,1},3));
ranks = zeros(size(bestBSigs,1),size(bestBSigs,2),size(bestBSigs{1,1},3));

N = size(bestBSigs{1,1},1);


for i = 1:size(bestBSigs,1)
    for j = 1:size(bestBSigs,2)
        for t = 1:size(bestBSigs{1,1},3)
            norm1s(i,j,t) = norm(reshape(bestBSigs{i,j}(:,:,t), [N N]), 1);
            norm2s(i,j,t) = norm(reshape(bestBSigs{i,j}(:,:,t), [N N]), 2);
            normInfs(i,j,t) = norm(reshape(bestBSigs{i,j}(:,:,t), [N N]), inf);
            normFros(i,j,t) = norm(reshape(bestBSigs{i,j}(:,:,t), [N N]), 'fro');
            ranks(i,j,t) = rank(reshape(bestBSigs{i,j}(:,:,t), [N N]));
        end
    end
end

