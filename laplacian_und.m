function lcen = laplacian_und(CIJ)
%LAPLACIAN_UND      laplacian centrality
%
%   lcen = laplacian_und(CIJ)
%
% this function only considers undirected binary/weighted matrices with 0 diagonal.
% computes laplacian centrality of each node
% outputs lcen (vector)
%
% -David Grayson 2014

m=size(CIJ,1);
CIJ(1:m+1:end)=0; %ensure diagonal is 0
X=zeros(m,m);
X(1:m+1:end)=sum(CIJ); %matrix X has node degrees along diagonal
L=X-CIJ; %laplacian matrix

LE=sum(eig(L).^2); %laplacian energy
%LE=sum(abs(eig(L))); %laplacian energy

Xi=zeros(m-1,m-1);
for i=1:m
    CIJi=CIJ;
    CIJi(i,:)=[];CIJi(:,i)=[]; %remove node
    Xi(1:m:end)=sum(CIJi);
    Li=Xi-CIJi;
    LEi(i)=sum(eig(Li).^2); %laplacian energy for node removed
end

lcen=(LE-LEi)/LE; %laplacian centrality
