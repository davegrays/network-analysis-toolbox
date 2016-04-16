function Mout = groupMatrix_3D(M)
%GROUPMATRIX_3D     retain only non-zero values across all subjects
%i.e. set 0's in any subject matrix to 0's in every matrix
%
%    Mout = groupMatrix_3D(M)
%
% -David Grayson 2014

%get size of input matrix
[sx, sy, sz]=size(M);

%get 3D-indices of 0 values
idx = find(M==0);
[xi, yi, zi] = ind2sub(size(M),idx);

%convert to unique 2D indices
I=sub2ind([sx sy],xi,yi);
I=unique(I);
if isempty(I)
    Mout=M;
    return
end
[xi, yi]=ind2sub([sx sy],I);

%convert back to 2D indices covering all subs
xi_all=repmat(xi,sz,1);
yi_all=repmat(yi,sz,1);

%make the 3rd dim index repeat over all subs (sub1, sub1, sub2 sub2, etc.)
zi=ones(length(xi),1);
zi_all=zi;
for sub=2:sz
    zi_all=cat(1,zi_all,zi*sub);
end

%convert 3D indices to vector
I=sub2ind(size(M),xi_all,yi_all,zi_all);

%zero indices
M(I)=0;
Mout=M;