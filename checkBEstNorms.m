norm1s = zeros(size(bayesSigs,1),size(bayesSigs,2),size(bayesSigs{1,1},3));
norm2s = zeros(size(bayesSigs,1),size(bayesSigs,2),size(bayesSigs{1,1},3));
normInfs = zeros(size(bayesSigs,1),size(bayesSigs,2),size(bayesSigs{1,1},3));
normFros = zeros(size(bayesSigs,1),size(bayesSigs,2),size(bayesSigs{1,1},3));
ranks = zeros(size(bayesSigs,1),size(bayesSigs,2),size(bayesSigs{1,1},3));

N = size(bayesSigs{1,1},1);


for i = 1:size(bayesSigs,1)
    for j = 1:size(bayesSigs,2)
        for t = 1:size(bayesSigs{1,1},3)
            norm1s(i,j,t) = norm(reshape(bayesSigs{i,j}(:,:,t), [N N]), 1);
            norm2s(i,j,t) = norm(reshape(bayesSigs{i,j}(:,:,t), [N N]), 2);
            normInfs(i,j,t) = norm(reshape(bayesSigs{i,j}(:,:,t), [N N]), inf);
            normFros(i,j,t) = norm(reshape(bayesSigs{i,j}(:,:,t), [N N]), 'fro');
            ranks(i,j,t) = rank(reshape(bayesSigs{i,j}(:,:,t), [N N]));
        end
    end
end

meanN1s = mean(mean(norm1s,3),2);
meanN2s = mean(mean(norm2s,3),2);
meanInfs = mean(mean(normInfs,3),2);
meanFros = mean(mean(normFros,3),2);

meanN1s = [meanN1s(5); meanN1s(1:4); meanN1s(6:8)];
meanN2s = [meanN2s(5); meanN2s(1:4); meanN2s(6:8)];
meanInfs = [meanInfs(5); meanInfs(1:4); meanInfs(6:8)];
meanFros = [meanFros(5); meanFros(1:4); meanFros(6:8)];

corr(wishLPs, meanN1s)
corr(wishLPs, meanN2s)
corr(wishLPs, meanInfs)
corr(wishLPs, meanFros)

corr(wishLPs, meanN1s, 'type', 'Spearman')
corr(wishLPs, meanN2s, 'type', 'Spearman')
corr(wishLPs, meanInfs, 'type', 'Spearman')
corr(wishLPs, meanFros, 'type', 'Spearman')

disp('yyDists:')

corr(yyDists, meanN1s)
corr(yyDists, meanN2s)
corr(yyDists, meanInfs)
corr(yyDists, meanFros)

corr(yyDists, meanN1s, 'type', 'Spearman')
corr(yyDists, meanN2s, 'type', 'Spearman')
corr(yyDists, meanInfs, 'type', 'Spearman')
corr(yyDists, meanFros, 'type', 'Spearman')