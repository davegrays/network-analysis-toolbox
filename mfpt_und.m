function [M,Mrec,Mu,Ml] = mfpt_und(W,local)
%MFPT_UND     Global mean first passage time, local mean first passage time.
%
%   Mglob = mfpt_und(W);
%   Mlocal = mfpt_und(W,1);
%
%   The global mfpt is the average mfpt of all edges Tij where i~=j
%
%   The local mfpt is the average mfpt computed on
%   each node excluding edges Gij where i=j
%
%   Mean recursion is a local metric (recursive or self-mfpt) computed on each node, i.e. Gij where i=j.
%
%   Inputs:     W,              weighted or binary undirected connection matrix
%               local,          optional argument
%                                   local=0 computes global (default)
%                                   local=1 computes local
%
%   Output:     Mglob,          global mfpt (scalar)
%               Mloc,           local mfpt (vector)
%
% -David Grayson 2014

N = size(W,1);
oneu=triu(ones(N,N),1);
onel=tril(ones(N,N),-1);

%generate the one-step transition matrix (an asymmetric probability matrix)
P=W./repmat(sum(W),N,1);

%run the mfpt function for each edge
ET=zeros(N,N);
for i=1:N
    for j=1:N
        ET(i,j)=mfpt(P,N,i,j);
    end
end
%ET=(ET+ET')/2; %keep this commented out for directed info

Mrec=ET(1:N+1:end);         %mean recursion (vector)
Mu=sum(ET.*oneu)/(N-1);     %mfpt upper vector (from node to all other)
Ml=sum(ET.*onel)/(N-1);     %mfpt lower vector (from all other to node)

if exist('local','var') && local
    ET(1:N+1:end) = 0;           %set diagonal to 0
    M=sum(ET)/(N-1);            %local mfpt total (commute time vector)
else
    ET(1:N+1:end) = 0;         %set diagonal to 0
    M=sum(ET(:))/(N*(N-1));    %total mfpt (scalar)
end


    function ETij = mfpt(P,N,i,j)
        % This function calculates the mean first passage time
        % for a Markov Chain - to use specify states i and j,
        % the one step transition matrix P, and N - the size of P
        % the answer is placed in ETij
        pi0 =  zeros(1,N);
        pi0(i) = 1;
        if i ~= j
            for r = 1:N
                for c = 1:N
                    if r ~= j
                        if c ~= j
                            if r < j
                                m = r;
                            else
                                m = r-1;
                            end
                            if c < j
                                k = c;
                            else
                                k = c-1;
                            end
                            R(m,k) = P(r,c);
                            pij0(1,k) = pi0(1,c);
                        end
                    end
                end
            end
            N1 = N-1;
            A = eye(N1)-R;
            e = ones(N1,1);
            AI = inv(A);
            ETij = pij0*AI*e;
        else
            % for i=j ET_ij is the mean recurrence time = 1/sspi_j
            bz = zeros(N-1,1);
            B = [bz
                1];
            I = eye(N);
            R = (P-I)';
            AU = R(1:N-1, 1:N);
            e = ones(1,N);
            A = [AU
                e];
            sspi = A\B;
            ETij = 1/sspi(j);
        end
