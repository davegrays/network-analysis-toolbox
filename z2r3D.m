function rmat3D=z2r3D(zmat3D)
%% rmat3D=z2r3D(zmat3D)    (UN)transforms the r(z) matrices
%% into r matrices
% assumes 2D matrices in zmat3D are stacked along 3rd dimension
% will set diagonals of 2D mats to 1
%
% -DS Grayson 2015

rmat3D=(exp(2*zmat3D)-1)./(exp(2*zmat3D)+1);

n=size(rmat3D,1);
for c=1:size(rmat3D,3)
    cm=c-1;
    rmat3D(cm*n^2+1:n+1:c*n^2)=1;
end