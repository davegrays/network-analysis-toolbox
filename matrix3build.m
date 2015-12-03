function [symmat volnorm] = matrix3build(seeddir,seeds,netdir)
%matrix3build    Consructs connectivity network using probtrackx2's matrix3
%output
%
%   [symmat volnorm] = matrix3build(seeddir,seeds,netdir)
%
%   Inputs:
%   seeddir is directory containing the nifti files for all seed regions
%   seeds is the list of filenames for all seed regions
%   netdir is the directory containing 'fdt_matrix3.dot' and
%   'coords_for_fdt_matrix3' files
%
%   Outputs:
%   symmat is the symmetrized region-to-region connectivity matrix weighted
%   by number of streamlines
%   volnorm is symmat where each edge is divided by (regioni+regionj)/2
%

%%%%%%%
%%%%%%%
BigM=spconvert(load([netdir 'fdt_matrix3.dot']));
c=load([netdir 'coords_for_fdt_matrix3']); c=c(:,4);
rois=unique(c);

M=zeros(length(rois));
for i=1:length(rois)
    seedmask = read_avw([seeddir '/' seeds{i}]);
    regsize(i)=sum(sum(sum(seedmask)));
    disp(['region ' num2str(i) ': ' seeds{i} ' has volume ' num2str(regsize(i))]);
    for j=1:length(rois)
        M(i,j) = sum(sum(BigM(c==rois(i),c==rois(j))));
        disp(['connection ' num2str(i) 'x' num2str(j) 'has ' num2str(M(i,j))]);
    end
end
%%%%%%%
%%%%%%%

%% symmetrize
symmat=M+M';
n=length(M);
symmat(1:n+1:end)=diag(M);

%% make volume-normalized version
for i=1:length(seeds)
    for j=1:length(seeds)
        volnorm(i,j)=symmat(i,j)*2/(regsize(i)+regsize(j));
        disp(['connection ' num2str(i) 'x' num2str(j) ' has volume normed ' num2str(volnorm(i,j))]);
    end
end
    