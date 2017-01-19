function [Y,p] = matrices2multidim(m3d,groups,dims,correlation,usenodes,testSignificance)
%matrices2multidim     plots multidimensionally embedded locations for 2D matrices (subjects) stacked along 3rd
%dimension.
%
%    [Y,p] = matrices2multidim(m3d,groups,dims,correlation,usenodes,testSignifiance)
%
%   INPUTS:
%   - m3d is your subject_array_3D
%   - group is a 1D numerical vector of group assignments (i.e. 1, 2, 3,
%   etc.) for each subject. It should correspond to the position of
%   subjects in subject_array_3D
%   - dims is how many dimensions you want to plot in (2 or 3)
%   - correlation is 'Pearson' or 'Spearman'
%   - usenodes is either 0 (to include all edge weights) or 1 (for just node
%   strengths)
%   - testSignificance is either 0 or 1 to permutation test signifiance of
%   within-group similarity being higher than between group (5000 perms)
%
%   EXAMPLES:
%   matrices2multidim(subject_array_3D,groups,2,'PR',0)
%   matrices2multidim(subject_array_3D,groups,3,'SR',1)
%

%% convert 2D mats stacked on 3rd dim to 1D mats stacked on 2nd dim
[mlen,~,slen]=size(m3d); %# of nodes and # of subjects
I=find(triu(ones(mlen,mlen),1)); %find upper triangular indices, excluding
                                    %diagonal
for s=1:slen
    s2d=m3d(:,:,s);
    if usenodes == 1
        m2d(:,s)=strengths_und(s2d);
    else
        m2d(:,s)=s2d(I);
    end
end

%% get between-subject correlation matrix
if strcmp(correlation,'Pearson')
    D=corr(m2d,'type','Pearson');
elseif strcmp(correlation,'Spearman')
    D=corr(m2d,'type','Spearman');
else
    error('distance measure must be Pearson or Spearman.')
end

%% get x,y,z locations for each subject and plot
Y=mdscale(D,dims);
scatter(Y(:,1),Y(:,2),50,groups,'filled');
title('subject scores');

%% z-transform the correlations (for statistical testing purposes)
D=r2z3D(D);

%% test whether group 1 subjects are more similar to each other than group 2 subjects are to each other
group_numbers=unique(groups);
g1_within_row = groups==group_numbers(1);
g2_within_row = groups==group_numbers(2);
g1=0;g2=0;
for s=1:slen
    if g1_within_row(s) == 1
        g1=g1+1;
        g1_within_mat(g1,:)=D(s,g1_within_row);
    elseif g2_within_row(s) == 1
        g2=g2+1;
        g2_within_mat(g2,:)=D(s,g2_within_row);
    end
end
g1_within_mat(1:g1+1:end)=0;g2_within_mat(1:g2+1:end)=0;
g1_subject_avgR = sum(g1_within_mat) / (g1 - 1);
g2_subject_avgR = sum(g2_within_mat) / (g2 - 1);
disp(['group1 n = ' num2str(length(g1_subject_avgR)) ', avg r(z) = ' num2str(mean(g1_subject_avgR)) '; group2 n = ' num2str(length(g2_subject_avgR)) ', avg r(z) = ' num2str(mean(g2_subject_avgR))]);
figure();imagesc(g1_within_mat);colorbar
figure();imagesc(g2_within_mat);colorbar
[~,P_t,~,STATS_t] = ttest2(g1_subject_avgR, g2_subject_avgR, 'vartype', 'unequal');
disp(['differences in intragroup idosynracy: P = ' num2str(P_t, '%0.5f')]);
STATS_t


%% visualize data-driven modular structure and compute overlap (chi-square) with a priori groups
% figure();
% ci = modularity_louvain_und(D);
% [reordered_ci, reordered_D] = reorder_mod(D,ci);
% imagesc(reordered_D);
% disp([num2str(length(unique(ci))) ' data-driven modules']);
% [table,chi2,p] = crosstab(ci,groups)

p=1;
if exist('testSignificance','var') && testSignificance    
    %% run permutation test to see if average r-value (z-value) is greater within-group than between
    %find observed within-group minus between
    [wg_mat, bg_mat] = make_within_mat(groups);
    obs=mean(mean(D(wg_mat>0)))-mean(mean(D(bg_mat>0)));
    %generate permutations
    numperms=5000;
    null=zeros(1,numperms);
    for np=1:numperms
        permgroups=groups(randperm(length(groups)));
        [wg_mat, bg_mat] = make_within_mat(permgroups);
        null(np)=mean(mean(D(wg_mat>0)))-mean(mean(D(bg_mat>0)));
    end
    p=mean(null>obs);
end

    function [within_mat, between_mat] = make_within_mat(groupvec)
        lenvec=length(groupvec);
        within_mat=zeros(lenvec,lenvec);
        for m=1:length(groupvec)
            within_mat(m,groupvec==groupvec(m))=1;
        end
        between_mat=(within_mat==0)*1;
        within_mat(1:lenvec+1:end)=0;
    end

end