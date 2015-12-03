function SI_3D = convertMAT3D_SI_und(subject_array_3D)
%CONVERTMAT3D_SI_UND     Convert edges of adjacency matrix to
%search-information scores
%
% takes undirected, weighted or unweighted adjacency matrices in
% subject_array_3D. converts them to search information matrices.
% based on methods in Goni 2014 PNAS: Resting-brain functional connectivity
% predicted by analytic measures of network communication
%
% -David Grayson 2014

slen=size(subject_array_3D,3);

for su=1:slen
    A=subject_array_3D(:,:,su);
    strengths=strengths_und(A);
    lA=length(A);
    G=sparse(A);
    Gsi=zeros(lA,lA);
    %% loop through each edge
    for S=1:lA
        for T=1:lA
            if S==T
                Gsi(S,T)=0;
                continue
            end
            %% find the shortest path
            [dist, path, pred] = graphshortestpath(G, S, T, 'Directed', false);
            %% get the probability of the shortest path
            i=1:length(path)-1;
            j=2:length(path);
            wi=strengths(path(i)); %strengths of nodes in shortest path (excluding target)
            w_itoj=[];
            for n=i
                w_itoj(n)=A(path(i(n)),path(j(n))); %serial weights of edges in shortest path
            end
            probels=w_itoj./wi;
            prob=prod(probels); %probability of shortest path!
            %% get search information of this path
            Gsi(S,T)=-log2(prob);
        end
    end
    
    %% symmetrize
    Gsi=(Gsi+Gsi')/2;
    
    %% add to 3D matrix
    SI_3D(:,:,su)=Gsi;
end
