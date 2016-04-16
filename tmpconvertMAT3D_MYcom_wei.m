function COM_3D = tmpconvertMAT3D_com_wei(subject_array_3D,mat3d_2,order,up_to_and_including,af)
%tmpCONVERTMAT3D_MYCOM_WEI     Convert edges of lesioned adjacency matrix to
%modified communicability scores
%
%   COM_3D = tmpconvertMAT3D_MYCOM_WEI(subject_array_3D,mat3d_2,order,up_to_and_including,af);
%
%   Inputs:
%   - subject_array_3D is a 3D matrix of individual 2D weighted
%   (un)directed matrices (lesioned) with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0
%   - mat3d_2 is the same but represents the unlesioned matrices
%   - order means you want to include walks up to what length (1 is
%   monosynaptic, 2 is disynaptic, 3 trisynaptic, etc.)
%   .... set order to 0 if you want to include walks of infinity length
%   - up_to_and_including means that you include all walks up to and
%   including the length specified by order (1) or walks only of the
%   length specified by order (0).
%   - af is attenuation factor: the penalty factor by which you multiply
%   for every additional step taken (0<af<1)
%   .... set af to '!' if you want to use factorial attentuation
%
%   Example: G_3D = convertMAT3D_MYcom_wei(unlesioned_mat_3D,lesioned_mat_3D,5,1,'!');
%
% -David Grayson 2015


[sx,sy,slen]=size(subject_array_3D);

for s=1:slen
    W=subject_array_3D(:,:,s); %lesioned SC matrix
    X=mat3d_2(:,:,s); %unlesioned SC matrix
    
%     norm=sqrt(sum(X)'*sum(X));
%     norm(:,27)=[];norm(27,:)=[]; %removing amygdala
%     W(:,27)=[];W(27,:)=[]; %removing amygdala
%     G=expm(W./norm);            %communicability matrix of lesioned SC 

    W=W./sqrt(sum(X)'*sum(X)); %lesioned matrix normalized against unlesioned

    if order == 0
        G=expm(W);            %communicability matrix of lesioned SC
        COM_3D(:,:,s)=G;
        continue
    end

    G=zeros(sx,sy); %initialize MY communicability matrix
    for o=1:order
        if up_to_and_including == 0 && o ~= order
            continue %skip to last walk length
        end
        if strcmp(af,'!')
            G=G+(W^o)./factorial(o);      %add to MY communicability matrix
        else
            G=G+(W^o).*af^(o-1);      %add to MY communicability matrix
        end
    end
    
%     newm=zeros(40,40); %piecing the matrix back together
%     newm(1:26,1:26)=G(1:26,1:26);
%     newm(28:40,1:26)=G(27:39,1:26);
%     newm(1:26,28:40)=G(1:26,27:39);
%     newm(28:40,28:40)=G(27:39,27:39);
%     G=newm;

    COM_3D(:,:,s)=G;
end
