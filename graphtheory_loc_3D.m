function [Gout G_METRICS] = graphtheory_loc_3D(M,Mtype,stren,clu,eff_loc,lap,clos,betw,eig,com,subg,CBC,mfpt,mrec,mfptFROM,mfptTO)
%GRAPHTHEORY_LOC_3D     Global graph theoretical metrics.
%
%   [Gout G_METRICS] = graphtheory_loc_3D(M,Mtype,stren,clu,eff_loc,lap,close,betw,eig,com,subg,CBC,mfpt,mrec,mfptFROM,mfptTO)
%
%   i.e. [Gout G_METRICS]=graphtheory_loc_3D(M,'wei',1,0,1,0,1,1,1,0,0,0,0,0,0,0)
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
%Gout is 3D matrix where metrics (rows) are ordered according to position
%in the command, subjects (columns) and regions (3rd dimension) are in corresponding order of the 3D
%input matrix. metrics given as 0's in the command will be excluded from
%output. i.e. the above command will produce a 4xNxR matrix where N is
%the size of the input matrix M's 3rd dimension and R is size of M's 1st&2nd
%dimension
%G_METRICS is a cell array listing the names of the metrics for
%corresponding columns of Gout
%
% -David Grayson 2014

if strcmp(Mtype,'wei')
    for s=1:size(M,3)
        S=M(:,:,s);
        g=0;
        if exist('stren','var') && stren
            g=g+1;Gout(s,g,:)=sum(S); %strength/degree
        end
        if exist('clu','var') && clu
            g=g+1;Gout(s,g,:)=clustering_coef_wu(S); %clustering coefficient
        end
        if exist('eff_loc','var') && eff_loc
            g=g+1;Gout(s,g,:)=efficiency_wei(S,1); %local efficiency
        end
        if exist('lap','var') && lap
            g=g+1;Gout(s,g,:)=laplacian_und(S); %laplacian centrality
        end
        if exist('clos','var') && clos
            g=g+1;Gout(s,g,:)=closeness_wei(S); %closeness centrality
        end
        if exist('betw','var') && betw
            G=S;E=find(G); G(E)=1./G(E);
            g=g+1;Gout(s,g,:)=betweenness_wei(G); %betweenness centrality
        end
        if exist('eig','var') && eig
            g=g+1;Gout(s,g,:)=eigenvector_centrality_und(S); %eigenvector centrality
        end
        
        if exist('com','var') && com && exist('subg','var') && subg
            g=g+1;[Gout(s,g,:) Gout(s,g+1,:)]=communicability_wei(S,1); %communicability and subgraph centrality
            g=g+1;
        elseif exist('com','var') && com
            g=g+1;[Gout(s,g,:) tmp]=communicability_wei(S,1); %communicability
        elseif exist('subg','var') && subg
            g=g+1;[tmp Gout(s,g,:)]=communicability_wei(S,1); %subgraph centrality
        end
        
        if exist('CBC','var') && CBC
            g=g+1;Gout(s,g,:)=communicability_centrality_wei(S); %communicability centrality
        end
        
        if exist('mfpt','var') && com && exist('mrec','var') && mrec
            g=g+1;[Gout(s,g,:) Gout(s,g+1,:) Gout(s,g+2,:) Gout(s,g+3,:)]=mfpt_und(S,1); %mfpt and mean recursion
            g=g+3;
        elseif exist('mfpt','var') && mfpt
            g=g+1;[Gout(s,g,:) tmp]=mfpt_und(S,1); %mfpt
        elseif exist('mrec','var') && mrec
            g=g+1;[tmp Gout(s,g,:)]=mfpt_und(S,1); %mean recursion
        end
    end
elseif strcmp(Mtype,'bin')
    M(M>0)=1; %binarize
    for s=1:size(M,3)
        S=M(:,:,s);
        g=0;
        if exist('stren','var') && stren
            g=g+1;Gout(s,g,:)=sum(S); %strength/degree
        end
        if exist('clu','var') && clu
            g=g+1;Gout(s,g,:)=clustering_coef_bu(S); %clustering coefficient
        end
        if exist('eff_loc','var') && eff_loc
            g=g+1;Gout(s,g,:)=efficiency_bin(S,1); %local efficiency
        end
        if exist('lap','var') && lap
            g=g+1;Gout(s,g,:)=laplacian_und(S); %laplacian centrality
        end
        if exist('clos','var') && clos
            g=g+1;Gout(s,g,:)=closeness_bin(S); %closeness centrality
        end
        if exist('betw','var') && betw
            g=g+1;Gout(s,g,:)=betweenness_bin(S); %betweenness centrality
        end
        if exist('eig','var') && eig
            g=g+1;Gout(s,g,:)=eigenvector_centrality_und(S); %eigenvector centrality
        end
        
        if exist('com','var') && com && exist('subg','var') && subg
            g=g+1;[Gout(s,g,:) Gout(s,g+1,:)]=communicability_bin(S,1); %communicability and subgraph centrality
            g=g+1;
        elseif exist('com','var') && com
            g=g+1;[Gout(s,g,:) tmp]=communicability_bin(S,1); %communicability
        elseif exist('subg','var') && subg
            g=g+1;[tmp Gout(s,g,:)]=communicability_bin(S,1); %subgraph centrality
        end
        
        if exist('CBC','var') && CBC
            g=g+1;Gout(s,g,:)=communicability_centrality_bin(S); %communicability centrality
        end
        
        if exist('mfpt','var') && com && exist('mrec','var') && mrec
            g=g+1;[Gout(s,g,:) Gout(s,g+1,:) Gout(s,g+2,:) Gout(s,g+3,:)]=mfpt_und(S,1); %mfpt and mean recursion
            g=g+3;
        elseif exist('mfpt','var') && mfpt
            g=g+1;[Gout(s,g,:) tmp]=mfpt_und(S,1); %mfpt
        elseif exist('mrec','var') && mrec
            g=g+1;[tmp Gout(s,g,:)]=mfpt_und(S,1); %mean recursion
        end
    end
else
    error('ERROR: Mtype must be either "wei" or "bin"');
end


g=0;
if exist('stren','var') && stren
    g=g+1;G_METRICS{1,g}='stren';
end
if exist('clu','var') && clu
    g=g+1;G_METRICS{1,g}='clu';
end
if exist('eff_loc','var') && eff_loc
    g=g+1;G_METRICS{1,g}='eff_loc';
end
if exist('lap','var') && lap
    g=g+1;G_METRICS{1,g}='lap';
end
if exist('clos','var') && clos
    g=g+1;G_METRICS{1,g}='close';
end
if exist('betw','var') && betw
    g=g+1;G_METRICS{1,g}='betw';
end
if exist('eig','var') && eig
    g=g+1;G_METRICS{1,g}='eig';
end
if exist('com','var') && com
    g=g+1;G_METRICS{1,g}='com';
end
if exist('subg','var') && subg
    g=g+1;G_METRICS{1,g}='subg';
end
if exist('CBC','var') && CBC
    g=g+1;G_METRICS{1,g}='CBC';
end
if exist('mfpt','var') && mfpt
    g=g+1;G_METRICS{1,g}='mfpt';
end
if exist('mrec','var') && mrec
    g=g+1;G_METRICS{1,g}='mrec';
end
if exist('mfptFROM','var') && mfptFROM
    g=g+1;G_METRICS{1,g}='mfptFROM';
end
if exist('mfptTO','var') && mfptTO
    g=g+1;G_METRICS{1,g}='mfptTO';
end
G_METRICS{2,1}=Mtype;
