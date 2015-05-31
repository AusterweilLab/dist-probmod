function [structs] = runKT(dirName,T,M,ps,ktChs)
%RUNKT 

masterfile = ['tempsave' num2str(cputime) '.mat'];

save(masterfile);

if nargin < 4
   ps = setmyps(dirName,T,M); 
end
if nargin < 5
    ktChs = [1 1 1 1];
end
testStructsInds = setdiff([1 2 6 7] .* ktChs,0);
testDataInds = [1:length(ps.data)]; 

sindpair = reshape(repmat(testStructsInds,length(testDataInds),1), ...
                    [length(testStructsInds)*length(testDataInds) 1]);
dindpair = repmat(testDataInds', length(testStructsInds),1);

% pss = cell(length(testStructsInds), length(testDataInds));
names= cell(length(testDataInds),1);
structs = cell(length(testStructsInds), length(testDataInds));
llhistories = cell(length(testStructsInds), length(testDataInds));
modellls = cell(length(testStructsInds), length(testDataInds));
bestgraphs = cell(length(testStructsInds), length(testDataInds));
rind = 1;

for ind = 1:length(dindpair)
    dind = dindpair(ind);
    sind = sindpair(ind);
    disp(['running:     data:', ps.data{dind}, '     struct:' ps.structures{sind}]);
    
    [mtmp stmp  ntmp ltmp gtmp] = runmodel(ps, sind, dind, rind);

     succ = 0;
    while (succ == 0)
      try
        if exist(masterfile)
          currps = ps; load(masterfile); ps = currps;
        end
%         pss{sind,dind,rind} = ps;
        modellls{sind, dind} = mtmp;  
        structs{sind,dind}  = stmp;
        names{dind} = ntmp;		   
        llhistories{sind, dind} = ltmp;
        bestgraphs{sind,dind} = gtmp;
        save(masterfile, 'modellls', 'structs', 'names', ...
			 'llhistories', 'bestgraphs'); 
        succ = 1;
      catch
        succ = 0;
        disp('error reading masterfile');
        pause(10*rand);
      end
    end
    
end


end

