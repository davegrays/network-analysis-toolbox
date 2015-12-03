function springembed(zmat,ci,total_reglist,highlight_list)
%springembed     generate fruchterman-reingold spring embedding diagram on 2D adj
%mat zmat and community structure ci.
%springembed(adj_mat,community_vector,region_list,highlight_list)
%optional arguments:
%integer array community_vector specifies community assignment of region at
%each corresponding index in adj_mat
%cell array of strings total_reglist used to identify indices by region name
%highlight_list specifies names of particular regions to circle in the embedding diagram
%
%DS Grayson 2015

if ~exist('ci','var')
    ci=ones(length(adj_mat),1);
end

%% find and remove isolated nodes/subnetworks of nodes
SB=sum(breadthdist(zmat));
iso=find(SB<max(SB));
zmat(iso,:)=[];zmat(:,iso)=[];
ci(iso)=[];
if exist('total_reglist','var')
    disp(['isolated nodes are ' total_reglist(iso)']);
    total_reglist(iso)=[];
end
disp(['isolated nodes are ' num2str(iso)]);

%% run springembedding (prefer fruchterman reingold over kamada-kawai for modularity)
zmat=double(zmat+zmat');zmat(zmat<0)=0;
G=sparse(zmat);
%xy=kamada_kawai_spring_layout(G,'maxiter',1000);
xy=fruchterman_reingold_force_directed_layout(G,'initial_temp',10,'iterations',1000);

%% generate plot lines and dots
[Xplot,Yplot]=gplot(zmat,xy,'k');hold on;
%can control line width, color, opacity here
p=patchline(Xplot,Yplot,'linestyle','-','edgecolor','k','linewidth',0.5,'edgealpha',0.7);hold on;
x=xy(:,1);
y=xy(:,2);
%can control circle size and outline color here
scatter(x,y,120,colors32tab(ci),'filled','MarkerEdgeColor','k');
set(gca,'drawmode','fast')

%% highlight regions if listed and connected
if exist('highlight_list','var')
    for l=1:length(highlight_list)
        node=find(strcmpi(highlight_list(l),total_reglist));
        if l==1 && ~isempty(node) %first node is left black triagnel
            plot(x(node),y(node),'ks','LineWidth',2,'MarkerSize',15)
        elseif l==2 && ~isempty(node) %next is green
            plot(x(node),y(node),'gs','LineWidth',2,'MarkerSize',15)
        elseif l==3 && ~isempty(node) %then right triangle
            plot(x(node),y(node),'k>','LineWidth',2,'MarkerSize',15)            
        elseif l==4 && ~isempty(node) %then green
            plot(x(node),y(node),'g>','LineWidth',2,'MarkerSize',15)
        elseif l>4 && ~isempty(node) %all others are circles
            plot(x(node),y(node),'bo','LineWidth',2,'MarkerSize',15)            
        end
    end
end

hold off;

function ctab = colors32tab(ci)
%reorder ci according to which modules start first
for i=1:max(ci);vec(i)=min(find(ci==i));end
%from ci(sort(vec)) to index of ci(sort(vec)))
from=ci(sort(vec));tmpci=ci;
for i=1:max(ci);tmpci(ci==from(i))=i;end
ci=tmpci;
%orange blue
%reference table
reftab=[1 0 0;
1 .75 0;
0 1 1;
0 1 0;
1 0 1;
1 1 0;
0 0 1;
0 .47 0;
.59 0 0;
0 .49 .49;
.49 0 .49;
.49 .49 0;
1 .67 1;
.67 1 1;
1 1 .67;
1 .86 .86;
.86 .86 1;
.86 1 .86;
.31 .27 0;
.55 100 0;
0 .24 0;
.31 0 0;
0 0 .39;
0 200 200;
200 200 0;
200 0 200;
0 .55 .31 ;
.55 0 .31;
0 .23 .55;
.23 0 .55;
50 0 50;
0 0 0];

%assign colors according to reference table
ctab=reftab(ci,:);