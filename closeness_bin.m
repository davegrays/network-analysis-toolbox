function [ccen] = closeness_bin(CIJ)
%CLOSENESS_CENTRALITY     closeness centrality.
%
%   [ccen] = closeness_bin(CIJ)

N=size(CIJ,1)-1;
D=distance_bin(CIJ);
ccen=N./sum(D);