function [Gout G_METRICS] = graphtheory_glob_3D(M,Mtype,clu,eff_loc,ass,tran,path,eff_glob,com,mfpt)
%GRAPHTHEORY_GLOB_3D     Global graph theoretical metrics.
%
%   [Gout G_METRICS] = graphtheory_glob_3D(M,Mtype,clu,eff_loc,ass,tran,path,eff_glob,com,mfpt)
%
%   i.e. [Gout G_METRICS]=graphtheory_glob_3D(M,'wei',1,0,1,1,1,1,1,0)
%
%computes metrics for each subject 2D matrix within 3D matrix input M
%assumes subjects are along 3rd dimension of input matrix and input matrix
%is symmetric with 0 diagonal
%Mtype ('wei' or 'bin') determines whether metrics should be computed on
%weighted input matrix or binarized, respectively. If 'bin' is specified,
%this function will binarize the input matrix.
%
%metrics are computed on each subject separately.
%
%outputs:
%Gout is 2D matrix where metrics (columns) are ordered according to position
%in the command, subjects (rows) are in corresponding order of the 3D
%input matrix. metrics given as 0's in the command will be excluded from
%output. i.e. the above command will produce a Nx6 matrix where N is
%the size of the input matrix M's 3rd dimension.
%G_METRICS is a cell array listing the names of the metrics for
%corresponding columns of Gout
%
% -David Grayson 2014

if strcmp(Mtype,'wei')
    for s=1:size(M,3)
        S=M(:,:,s);
        g=0;
        if exist('clu','var') && clu
            g=g+1;Gout(s,g)=mean(clustering_coef_wu(S)); %average clustering coefficient
        end
        if exist('eff_loc','var') && eff_loc
            g=g+1;Gout(s,g)=mean(efficiency_wei(S,1)); %average local efficiency
        end
        if exist('ass','var') && ass
            g=g+1;Gout(s,g)=assortativity_wei(S,0); %assortativity
        end
        if exist('tran','var') && tran
            g=g+1;Gout(s,g)=transitivity_wu(S); %transitivity
        end
        if exist('path','var') && path
            g=g+1;Gout(s,g)=charpath(distance_wei(1./S)); %characteristic path length
        end
        if exist('eff_glob','var') && eff_glob
            g=g+1;Gout(s,g)=efficiency_wei(S); %efficiency (global)
        end
        if exist('com','var') && com
            g=g+1;Gout(s,g)=communicability_wei(S); %total communicability
        end
        if exist('mfpt','var') && mfpt
            g=g+1;Gout(s,g)=mfpt_und(S); %total mean first passage time
        end
    end
elseif strcmp(Mtype,'bin')
    M(M>0)=1; %binarize
    for s=1:size(M,3)
        S=M(:,:,s);
        g=0;
        if exist('clu','var') && clu
            g=g+1;Gout(s,g)=mean(clustering_coef_bu(S)); %average clustering coefficient
        end
        if exist('eff_loc','var') && eff_loc
            g=g+1;Gout(s,g)=mean(efficiency_bin(S,1)); %average local efficiency
        end
        if exist('ass','var') && ass
            g=g+1;Gout(s,g)=assortativity_bin(S,0); %assortativity
        end
        if exist('tran','var') && tran
            g=g+1;Gout(s,g)=transitivity_bu(S); %transitivity
        end
        if exist('path','var') && path
            g=g+1;Gout(s,g)=charpath(distance_bin(S)); %characteristic path length
        end
        if exist('eff_glob','var') && eff_glob
            g=g+1;Gout(s,g)=efficiency_bin(S); %efficiency (global)
        end
        if exist('com','var') && com
            g=g+1;Gout(s,g)=communicability_bin(S); %total communicability
        end
        if exist('mfpt','var') && mfpt
            g=g+1;Gout(s,g)=mfpt_und(S); %total mean first passage time
        end
    end
else
    error('ERROR: Mtype must be either "wei" or "bin"');
end


g=0;
if exist('clu','var') && clu
    g=g+1;G_METRICS{1,g}='clu';
end
if exist('eff_loc','var') && eff_loc
    g=g+1;G_METRICS{1,g}='eff_loc';
end
if exist('ass','var') && ass
    g=g+1;G_METRICS{1,g}='ass';
end
if exist('tran','var') && tran
    g=g+1;G_METRICS{1,g}='tran';
end
if exist('path','var') && path
    g=g+1;G_METRICS{1,g}='path';
end
if exist('eff_glob','var') && eff_glob
    g=g+1;G_METRICS{1,g}='eff_glob';
end
if exist('com','var') && com
    g=g+1;G_METRICS{1,g}='com';
end
if exist('mfpt','var') && mfpt
    g=g+1;G_METRICS{1,g}='mfpt';
end
G_METRICS{2,1}=Mtype;
