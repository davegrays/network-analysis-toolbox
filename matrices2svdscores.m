function [scores subjects groups_reordered varscores] = matrices2svdscores(m3d,groups,nodes,PCA)
%matrices2svdscores     plots svd scores for 2D matrices stacked along 3rd
%dimension
%
%    [scores subjects groups_reordered] = matrices2svdscores(m3d,groups)
%
%   INPUTS:
%   - m3d is your subject_array_3D
%   - group is a 1D numerical vector of group assignments (i.e. 1, 2, 3,
%   etc.) for each subject. It should correspond to the position of
%   subjects in subject_array_3D
%   - nodes is either 0 (to include all edge weights) or 1 (for just node
%   strengths)
%   - pca is optional argument: set to 1 if you want to run pca instead
%
%   EXAMPLES:
%   matrices2svdscores(subject_array_3D,groups,0)
%   matrices2svdscores(subject_array_3D,groups,0,1)
%
%   outputs will be arranged in order of ascending scores
%

%% convert 2D mats stacked on 3rd dim to 1D mats stacked on 2nd dim
mlen=size(m3d,1); %2D matrix size
slen=size(m3d,3); %# of subjects
I=find(triu(ones(mlen,mlen),1)); %find upper triangular indices, excluding
                                    %diagonal
for s=1:slen
    s2d=m3d(:,:,s);
    if nodes == 1
        m2d(:,s)=strengths_und(s2d);
    else
        m2d(:,s)=s2d(I);
    end
end

%% get svd scores for each subject
if exist('PCA','var') && PCA
    [V,S,U] = pca(m2d);
else
    [U,S,V] = svd(m2d);
end
scores=(V(:,2));
varscores=(U(:,2));

%% reorganize by group assignments
[scores subjects]=sort(scores);
groups_reordered=groups(subjects);

%% plot
scatter(1:length(scores),scores,50,groups_reordered,'filled');
title('subject scores');
figure();
scatter(1:length(varscores),varscores,50,'filled');
title('variable scores');
