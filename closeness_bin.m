function [ccen] = closeness_bin(CIJ)
%CLOSENESS_CENTRALITY     closeness centrality.
%
%   [ccen] = closeness_bin(CIJ)
%
% -David Grayson 2015

N=size(CIJ,1)-1;
D=distance_bin(CIJ);
ccen=N./sum(D);
