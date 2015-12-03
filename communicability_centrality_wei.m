function [CBC] = communicability_centrality_wei(W)
%COMMUNICABILITY_CENTRALITY_WEI     communicability centrality
%
%   CBC = communicability_centrality_wei(W);
%
%   The comunicability centrality of a node is the reduction in
%   communicability when all edges connected to said node are set to 0, as
%   described in Estrada et al., 2009 "Communicability betweenness in
%   complex networks."
%
%   W must be a weighted undirected or directed adjacency matrix
%   CBC will be a row vector of the communicability centralities of nodes
%
% -David Grayson 2014

n = size(W,1);
oneu=triu(ones(n,n),1);

Wn=W./sqrt(sum(W)'*sum(W));            %normalize weighted adj mat
G=expm(Wn);                 %communicability matrix

CBC=zeros(n,1);
for node=1:n
    Rn=Wn;Rn(n,:)=0;Rn(:,n)=0; %remove edges from adj mat
    rpq=oneu;rpq(node,:)=0;rpq(:,node)=0; %remove edges from indices to sum
    
    Gr=expm(Rn); %recompute communicability matrix
    
    TCrpq=sum(sum(G(rpq>0)));   %total communicability of rpq indices
    CBC(node)=(TCrpq-sum(sum(Gr(rpq>0))))/TCrpq; %proportion of reduced communicability
end

