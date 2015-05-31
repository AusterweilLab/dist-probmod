as = [10 20 40 80 160 320 640 1000 2000 4000 8000];
bs = as;

N = 10;
M = 100;
T = 100;

prSig = eye(N)*1/1350;

wishs = zeros(length(as), length(bs), length(trueSigs));
for a = 1:length(as)
    for b = 1:length(bs)
        for k = 1:length(trueSigs);
            wishs(a,b,k) = wishartinessLP(trueSigs{k},as(a),bs(b),prSig)/T;            
        end
    end
end

wishTop = zeros(length(as),length(bs));

for a = 1:length(as)
    for b = 1:length(bs)
        [val ind] = max(reshape(wishs(a,b,:), [8 1]));
        wishTop(a,b) = (ind == 1);
    end
end