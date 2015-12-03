function [CBC] = communicability_centrality_wei(A)
%COMMUNICABILITY_CENTRALITY_BIN     communicability centrality
%
%   CBC = communicability_centrality_bin(A);
%
%   The comunicability centrality of a node is the reduction in
%   communicability when all edges connected to said node are set to 0, as
%   described in Estrada et al., 2009 "Communicability betweenness in
%   complex networks."
%
%   A must be a binary undirected or directed adjacency matrix
%   CBC will be a row vector of the communicability centralities of nodes
%
% -David Grayson 2014

n = size(A,1);
oneu=triu(ones(n,n),1);

G=expm(A);                 %communicability matrix

CBC=zeros(n,1);
for node=1:n
    R=A;R(n,:)=0;R(:,n)=0; %remove edges from adj mat
    rpq=oneu;rpq(node,:)=0;rpq(:,node)=0; %remove edges from indices to sum
    
    Gr=expm(R); %recompute communicability matrix
    
    TCrpq=sum(sum(G(rpq>0)));   %total communicability of rpq indices
    CBC(node)=(TCrpq-sum(sum(Gr(rpq>0))))/TCrpq; %proportion of reduced communicability
end

