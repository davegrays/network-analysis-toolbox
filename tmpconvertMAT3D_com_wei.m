function COM_3D = tmpconvertMAT3D_com_wei(subject_array_3D,mat3d_2)
%tmpCONVERTMAT3D_COM_WEI     Convert edges of adjacency matrix to
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
    W=subject_array_3D(:,:,s); %lesioned SC matrix
    X=mat3d_2(:,:,s); %unlesioned SC matrix
    G=expm(W./sqrt(sum(X)'*sum(X)));            %communicability matrix of lesioned SC matrix using rescaling factor from unlesioned SC matrix

    COM_3D(:,:,s)=G;
end