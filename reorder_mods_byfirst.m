function Ci_reordered = reorder_mods_byfirst(Ci)
%reorder_mods_by_first      reorders ci according to which modules start first
for i=1:max(Ci);vec(i)=min(find(Ci==i));end
from=Ci(sort(vec));Ci_reordered=Ci;
for i=1:max(Ci);Ci_reordered(Ci==from(i))=i;end