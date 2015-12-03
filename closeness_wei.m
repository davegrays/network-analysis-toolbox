function [ccen] = closeness_wei(CIJ)
%CLOSENESS_CENTRALITY     closeness centrality.
%
%   [ccen] = closeness_wei(CIJ)
%
% -David Grayson 2014

n=size(CIJ,1);
ind = CIJ~=0;
CIJ(ind) = 1./CIJ(ind);                             %connection-length matrix

D=distance_wei(CIJ);
D(1:n+1:end)=0;              %set diagonal to 0
ccen=(n-1)./(sum(D)/2);
