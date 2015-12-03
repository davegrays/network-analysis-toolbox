function ET_3D = convertMAT3D_mfpt_und(subject_array_3D)
%CONVERTMAT3D_MFPT_UND     Convert edges of adjacency matrix to mean first passage times
%
%   ET_3D = convertMAT3D_mfpt_und(subject_array_3D);
%
%   Inputs:
%   subject_array_3D is a 3D matrix of individual 2D binary/weighted
%   undirected matrices with subjects in 3rd dimension
%   diagonal of 2D matrices should be 0


slen=size(subject_array_3D,3);
N = size(subject_array_3D,1);

for s=1:slen
    W=subject_array_3D(:,:,s);
    %generate the one-step transition matrix (an asymmetric probability matrix)
    P=W./repmat(sum(W),N,1);
    %run the mfpt function for each edge
    ET=zeros(N,N);
    for i=1:N
        for j=1:N
            ET(i,j)=mfpt(P,N,i,j);
        end
    end
    ET=(ET+ET')/2; %symmetrize %comment out this line if you want the directed information, which is more informative
    
    ET_3D(:,:,s)=ET;
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