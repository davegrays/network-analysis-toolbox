function Y = matrices2multidim(m3d,groups,dims,correlation,usenodes)
%matrices2multidim     plots multidimensionally embedded locations for 2D matrices (subjects) stacked along 3rd
%dimension.
%
%    Y = matrices2multidim(m3d,groups,dims,correlation,usenodes)
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
%
%   EXAMPLES:
%   matrices2multidim(subject_array_3D,groups,2,'PR',0)
%   matrices2multidim(subject_array_3D,groups,3,'SR',1)
%

%% convert 2D mats stacked on 3rd dim to 1D mats stacked on 2nd dim
mlen=size(m3d,1); %2D matrix size
slen=size(m3d,3); %# of subjects
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

%% get x,y,z locations for each subject
Y=mdscale(D,dims);

%% plot
scatter(Y(:,1),Y(:,2),50,groups,'filled');
title('subject scores');