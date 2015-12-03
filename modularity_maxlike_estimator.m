function Ci_vec = modularity_maxlike_estimator(am,iters,finetune)

% get community structure using the methodology described in
% Grayson et al 2014
Ci = zeros(iters,length(am));
for i = 1:iters
    if finetune==1
        ftCi = modularity_finetune_und(am); ftCi = modularity_finetune_und(am,ftCi);
        ftCi = modularity_finetune_und(am,ftCi); Ci(i,:)=ftCi;
    else
        Ci(i,:)=modularity_und(am);
    end
end

%build the within module adjacency matrix
wm_adj = zeros(length(am));
for n = 1:length(am)
    for i = 1:size(Ci,1)
        module = Ci(i,n);
        same_mod = Ci(i,:)==module;
        
        wm_adj(n,:) = wm_adj(n,:)+same_mod;
    end
end

% threshold matrix
wm_adj = wm_adj./size(Ci,1);
wm_adj(wm_adj>=.75)=1;
wm_adj(wm_adj<.75)=0;
wm_adj(eye(length(wm_adj))==1)=0;

% calculate pcoef with the newly formed community vec
Ci_vec = modularity_und(wm_adj)';
end
