function Q = compute_modularity(W,Ci)
%COMPUTE_MODULARITY     computes Q from input matrix and community vector.
%
%   Q = compute_modularity(W,ci)

N=length(W);
K=sum(W);                        %degree
m=sum(K);                               %number of edges (each undirected edge is counted twice)
B=W-(K.'*K)/m;                   %modularity matrix
s=Ci(:,ones(1,N));                      %compute modularity
Q=~(s-s.').*B/m;
Q=sum(Q(:));
