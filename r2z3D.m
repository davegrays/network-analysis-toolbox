function zmat3D=r2z3D(rmat3D)
%% zmat3D=r2z3D(rmat3D)    fisher z-transforms the correlation matrices
% assumes 2D matrices in rmat3D are stacked along 3rd dimension
% will set diagonals of 2D mats to 0
%
% -DS Grayson 2015

n=size(rmat3D,1);
for c=1:size(rmat3D,3)
    cm=c-1;
    rmat3D(cm*n^2+1:n+1:c*n^2)=0;
end
zmat3D=.5*log((1+rmat3D)./(1-rmat3D));
