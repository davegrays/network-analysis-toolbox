function COM_3D = convertMAT3D_com_wei(subject_array_3D)
%CONVERTMAT3D_COM_WEI     Convert edges of adjacency matrix to
%communicability scores
%
%   COM_3D = convertMAT3D_COM_WEI(subject_array_3D);
%
%   Inputs:
%   subject_array_3D is a 3D matrix of individual 2D weighted
%   undirected matrices with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0


slen=size(subject_array_3D,3);

for s=1:slen
    W=subject_array_3D(:,:,s);
    G=expm(W./sqrt(sum(W)'*sum(W)));            %communicability matrix

    COM_3D(:,:,s)=G;
end