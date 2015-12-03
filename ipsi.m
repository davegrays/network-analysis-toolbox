function [M_l_3D,M_r_3D,I_3D,hom_3D,contras_l_3D,contras_r_3D] = ipsi(subject_array_3D)
%ipsi    returns left hem, right hem, and averaged hem from BOTHhem matrix
%as well as information regarding homotopic and total contralateral
%connectivity for each node
%
% [M_l,M_r,I,hom,contras_l,contras_r] = ipsi(M)
%
% M must be adjacency matrix of size NxN (N is even number) or 3D stack of
% adjacency matrices NxNxS,
% where first N/2 nodes are left hem regions, second N/2 nodes are the
% corresponding right hem regions.
%
% outputs: M_l is left hem matrix, M_r is right hem matrix, I is average of
% left and right hem
% hom is array of homotopic connection weights (length N/2)
% contras_l and contras_r are total contralateral connectivity, including
% homotopic, for left and right hemi nodes respectively (length N/2)
%
% -David Grayson 2014

slen=size(subject_array_3D,3);

for s=1:slen
    M=subject_array_3D(:,:,s);
    M_l=M;M_r=M;lr=size(M,1);
    M_l(lr/2+1:end,:)=[];M_l(:,lr/2+1:end)=[];
    M_r(1:lr/2,:)=[];M_r(:,1:lr/2)=[];
    I=(M_l+M_r)/2; %ipsilateralized SC matrix
    
    contras_l=zeros(lr/2,1);
    contras_r=zeros(lr/2,1);
    hom=zeros(lr/2,1);
    for i=1:lr/2
        hom(i)=M(i,lr/2+i);
        contras_l(i)=sum(M(i,lr/2+1:end));
        contras_r(i)=sum(M(i+lr/2,1:lr/2));
    end
    
    M_l_3D(:,:,s)=M_l;
    M_r_3D(:,:,s)=M_r;
    I_3D(:,:,s)=I;
    hom_3D(s,:)=hom;
    contras_l_3D(s,:)=contras_l;
    contras_r_3D(s,:)=contras_r;
end
