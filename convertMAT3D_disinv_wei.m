function DIS_3D = convertMAT3D_disinv_wei(subject_array_3D)
%CONVERTMAT3D_DISINV_WEI     Convert edges of adjacency matrix to
%inverse distance scores. aka inverse path length scores
%
%   COM_3D = convertMAT3D_disinv_wei(subject_array_3D);
%
%   Inputs:
%   subject_array_3D is a 3D matrix of individual 2D weighted
%   undirected matrices with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0
%
% -David Grayson 2014

slen=size(subject_array_3D,3);
n=size(subject_array_3D,1);

for s=1:slen
    L=subject_array_3D(:,:,s);
    ind = L~=0;
    L(ind) = 1./L(ind);                             %connection-length matrix

    D=distance_wei(L);            %distance matrix (path length matrix)
    D=1./D;                       %invert distance
    D(1:n+1:end)=0;              %set diagonal to 0
    DIS_3D(:,:,s)=D;
end
