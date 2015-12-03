function Mout = matthresh_3D(M,ttype,tval)
%MATTHRESH_3D     threshold 2D matrices stacked along 3rd dimension
%
%    Mout = matthresh_3D(M,ttype,tval)
%
%applies a minimum threshold to each subject 2D matrix within 3D matrix
%input M. assumes subjects are along 3rd dimension of input matrix and that
%input matrix is symmetric undirected.
%thresholds (tval) are applied either in terms of matrix density 
%(ttype='dens'), total weight fraction (ttype='twf'), or individual
%connection weight (ttype='weight'). minimum density must also be expressed 
%as a fraction (0-1)

mlen=size(M,1); %2D matrix size
slen=size(M,3); %#subjects
I=find(triu(ones(mlen,mlen),1)); %find upper triangular indices
critI=round(length(I)*tval); %find threshold index for dens

for s=1:slen
    S=M(:,:,s);
    if tval ~= 0
        if strcmp(ttype,'weight')
            S(S < tval)=0; %apply weight threshold
        elseif strcmp(ttype,'dens')
            sorted=sort(S(I),'descend'); %order upper triangular elements
            S(S < sorted(critI))=0; %apply dens threshold
        elseif strcmp(ttype,'twf')
            S(S < sum(sum(S))/mlen*tval)=0; %apply twf threshold
        else
            error('ERROR: threshold type must be "dens", "twf", or "weight"')
        end
    end
    S(1:mlen+1:end)=0; %set diag to 0
    Mout(:,:,s)=S;
end