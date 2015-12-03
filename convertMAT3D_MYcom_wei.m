function COM_3D = convertMAT3D_MYcom_wei(subject_array_3D,order,af)
%CONVERTMAT3D_MYCOM_WEI     Convert edges of adjacency matrix to
%modified communicability scores
%
%   COM_3D = convertMAT3D_MYcom_wei(subject_array_3D,order,af);
%
%   Inputs:
%   - subject_array_3D is a 3D matrix of individual 2D weighted
%   undirected matrices with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0
%   - order means you want to include walks up to what length (1 is
%   monosynaptic, 2 is disynaptic, 3 trisynaptic, etc.)
%   - af is attenuation factor: the penalty factor by which you multiply
%   for every additional step taken (0<af<1)
%
%   Example: G_3D = convertMAT3D_MYcom_wei(subject_array_3D,5,.5);


slen=size(subject_array_3D,3);
sx=size(subject_array_3D,1);
sy=size(subject_array_3D,2);

for s=1:slen
    W=subject_array_3D(:,:,s);
    W=W./sqrt(sum(W)'*sum(W));            %normalize matrix
    
    G=zeros(sx,sy); %initialize MY communicability matrix
    for o=1:order
        G=G+(W^o).*af^(o-1);      %add to MY communicability matrix
    end

    COM_3D(:,:,s)=G;
end