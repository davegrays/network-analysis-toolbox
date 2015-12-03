function Ci_reordered = reorder_mods_byinput(Ci,from)
%reorder_mods_byinput      reorders ci according to reference vector from
Ci_reordered=Ci;
for i=1:max(Ci);Ci_reordered(Ci==from(i))=i;end