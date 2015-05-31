function ps = setmyps(dirName, T,M, ktChs, eRuns, wishRun)
%SETMYPS set my parameters for running charles' model on our code
global nautyInstalled;

if nargin == 0
   dirName = '/data/';
end

if nargin <= 1
   T = 1; 
end

if nargin <= 2
   M = 100; 
end

ps.structures = {'partition', 'chain', 'order', 'ring', 'hierarchy',...
			 'tree', 'grid', 'cylinder',...
    'partitionnoself',...
    'dirchain', 'dirchainnoself', 'undirchain', 'undirchainnoself',...
    'ordernoself', 'connected', 'connectednoself',...  
    'dirring', 'dirringnoself', 'undirring', 'undirringnoself',...
    'dirhierarchy', 'dirhierarchynoself', 'undirhierarchy', 'undirhierarchynoself',...
    };

% J = 1;
J = sum(ktChs)+length(eRuns)+wishRun;

b = [pwd, dirName];

ps.data = cell(T*J,1);
ps.dlocs = cell(T*J,1);


for t = 1:T
    curIt = 1;
    if ktChs(1) 
        ps.data{(t-1)*J+curIt} = [genRandPartSig(-1) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandPartSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    if ktChs(2) 
        ps.data{(t-1)*J+curIt} = [genRandChainSig(-1) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandChainSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    if ktChs(3) 
        ps.data{(t-1)*J+curIt} = [genRandTreeSig(-1) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandTreeSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    
    if ktChs(4) 
        ps.data{(t-1)*J+curIt} = [genRandGridSig(-1) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandGridSig(-1) num2str(t)];
        curIt = curIt+1;
    end
    
    for jEps = 1:length(eRuns)
        ps.data{(t-1)*J+curIt} = [genRandErdosSig(-1,eRuns(jEps)) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandErdosSig(-1,eRuns(jEps)) num2str(t)];
        curIt = curIt+1;
    end
    
    if wishRun
           ps.data{(t-1)*J+curIt} = [genRandWishSig(-1) num2str(t)];
        ps.dlocs{(t-1)*J+curIt} = [b genRandWishSig(-1) num2str(t)];
    end
    
        
end
%effective number of features for XX data
ps.repeats = ones(1,length(ps.data));

ps.simdim = {};

for i=1:length(ps.data)
  ps.simdim{i} = M;
end
%% HYPERPARAMETERS
ps.lbeta     = 0.4; % parameter for exponential prior on branch-lengths 
		    % lbeta is expected branch length 
ps.sigbeta   = 0.4; % parameter for exponential prior on 1/sigma 
		    % sigbeta is expected value of 1/sigma  
ps.sigmainit = (1/ps.sigbeta);   % initial value for regularization parameter
ps.theta     = (1-exp(-3));  % each additional node reduces prior by 3 


% DATA  -- which (if any) pre-processing steps to apply
% Feature data: simpleshiftscale -- make data zero mean, ensure that max
%				    entry in the covariance matrix is 1
%		makesimlike      -- transform data so that the largest
%				    entry in the covariance matrix is 1, and the
%			            smallest entry is 0
%	        none		 -- no pre-processing	

% Similarity data:  center	 -- center the similarity matrix
%		    none	 -- no pre-processing	


ps.datatransform = 'none'; % none, makesimlike, simpleshiftscale
ps.simtransform  = 'none';	       % none, center 


%% DISPLAY 
ps.showtruegraph     = 0; % show true graph. For artificial data only
ps.showinferredgraph = 0; % show inferred graph 
ps.showbestsplit     = 0; % picture each time a node is split
ps.showpreclean	     = 0; % show best graph  (pre cleaning) at each depth 
ps.showpostclean     = 0; % show best graph (post cleaning) at each depth 

% SPEED
% Optimizing the branch lengths is slow, and these options specify when
% this step will take place.

% 1: optimize branch lengths everywhere
% 2: optimize branch lengths once a node has been fully split
% 23: start out at 3 and finish at 2 
% 3: only optimize branch lengths once the best split has been chosen
% 4: only optimize branch lengths once per depth
% 5: maximize approximate score (only optimize branch lengths as a heuristic if
%				 search is otherwise finished)
% 54: speed 5 then 4
ps.speed = 54;

% CONSTRAINTS ON THE BRANCH LENGTHS
% external branches join entities to clusters.
% internal branches join clusters to clusters

ps.fixedall	     = 0;	% all branch lengths must be identical
ps.fixedinternal     = 0;	% internal branch lengths must be identical
ps.fixedexternal     = 0;	% external branch lengths must be identical
ps.prodtied	     = 0;	% each branch length in a "direct product"
				% graph (e.g. a grid) must equal the
				% corresponding branch length from the
				% corresponding component graph.

% Search strategies: 
%   intext   -- start with ps.fixedinternal = 1, ps.fixedexternal = 1
%	        then just ps.fixedexternal = 1.
%	        then remove all branch length constraints.

ps.init		     = 'intext'; % none, ext, int, intext, fixedall

% OTHER 
ps.gibbsclean = 1  ;	    % use heuristics to improve graph after each split
ps.nauty= nautyInstalled;   % is nauty installed? If so we'll save some
			    % time by only considering near misses up to
			    % isomorphism. Results in the PNAS paper
			    % were generated with this set to 1. It's not
			    % set to 0 for users who don't have nauty
			    % installed --- this might slow down the code
			    % but shouldn't change the results.
ps.outsideinit = '';	    % initialize with outside graph
ps.zglreg = 1;		    % regularize like Zhu, Ghahramani and Lafferty
			    %	    suggest (add terms along the entire
			    %	    diagonal of the precision matrix
ps.featforce = 0;	    % a square matrix is treated by default as a 
			    %       similarity matrix. Set this flag to 
			    %	    analyze a square feature matrix.

% We integrate out the parameters of the relational model. The next three
% parameters set up the parameter grid we consider.

ps.edgesumsteps  = 10;	    % number of magnitudes
ps.edgesumlambda = 2;	    % base of magnitudes
ps.edgeoffset    =-5;	    % first magnitude is base^offset

% initializing a relational structure:
%   none:     initialize with all objects in one cluster.
%   overd:    use a structure created with one object per cluster
%   external: use a structure from ps.relinitdir

ps.reloutsideinit='none';   

% Add path to appropriate directory if ps.reloutsideinit = 'external'
ps.relinitdir= '';


end

