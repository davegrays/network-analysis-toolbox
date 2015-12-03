function [C,subg] = communicability_bin(A,local)
%COMMUNICABILITY_BIN     Global communicability, local communicability.
%
%   Cglob = communicability_wei(A);
%   Clocal = communicability_wei(A,1);
%
%   The global comunicability is the average communicability of all edges
%   Gij where i~=j
%
%   The local communicability is the average communicability computed on
%   each node excluding edges Gij where i=j
%
%   Subgraph centrality is a local metric (recursive or self-communicability) computed on each node, i.e. Gij where i=j.
%
%   Inputs:     A,              binary undirected or directed connection matrix
%               local,          optional argument
%                                   local=0 computes global (default)
%                                   local=1 computes local
%
%   Output:     Cglob,          global communicability (scalar)
%               Cloc,           local communicability (vector)

n = size(A,1);

G=expm(A);                  %compute communicability matrix

subg=G(1:n+1:end);            %subgraph centrality (vector)

if exist('local','var') && local
    G(1:n+1:end) = 0;           %set diagonal to 0
    C=sum(G)/(n-1);            %local communicability (vector)
else
    G(1:n+1:end) = 0;           %set diagonal to 0
    C=sum(G(:))/(n*(n-1));    %total communicability (scalar)
end