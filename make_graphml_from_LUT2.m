function make_graphml_from_LUT2()
% run from FREESURFER/label directory after reconall and apply_parcellation.sh have been run /group_shares/FAIR_MCDON/CMP_beta/DIY_Parcellation/2078_S1_1/Markov/FREESURFER/label
%
% -Lisa Karstens 2014

FileName = 'Gordon_rh_LUT.txt'

graphml_outfile = 'Gordon';

fid = fopen(FileName);
text = textscan(fid,'%d %s %d %d %d %d');
fclose(fid); clear fid;

cols = length(text);
rows = size(text{1,1},1);

fid = fopen([graphml_outfile '.graphml'],'wt');
fprintf(fid,'<?xml version="1.0" encoding="utf-8"?><graphml xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">\n');
fprintf(fid,'  <key attr.name="dn_correspondence_id" attr.type="string" for="node" id="d6" />>\n');
fprintf(fid,'  <key attr.name="dn_fs_aseg_val" attr.type="string" for="node" id="d5" />>\n');
fprintf(fid,'  <key attr.name="dn_name" attr.type="string" for="node" id="d4" />>\n');
fprintf(fid,'  <key attr.name="dn_correspondence_id" attr.type="string" for="node" id="d3" />\n');
fprintf(fid,'  <key attr.name="dn_hemisphere" attr.type="string" for="node" id="d2" />\n');
fprintf(fid,'  <key attr.name="dn_fsname" attr.type="string" for="node" id="d1" />\n');
fprintf(fid,'  <key attr.name="dn_region" attr.type="string" for="node" id="d0" />\n');
fprintf(fid,'  <graph edgedefault="undirected" id="">\n');

for i = 2:rows
    node=text{1,1}(i);
    fprintf(fid,['    <node id="' num2str(node) '">\n']);
    if node <10;
        temp='true';
    else
        temp='false';
    end
    fprintf(fid,['      <data key="d0">cortical</data>\n']);
    fprintf(fid,['      <data key="d1">' char(text{1,2}(i)) '</data>\n']);
    fprintf(fid,['      <data key="d2">right</data>\n']);
    if strcmp(temp,'true')
        fprintf(fid,['      <data key="d3">' ['200' num2str(text{1,1}(i))] '</data>\n']);
    else
        fprintf(fid,['      <data key="d3">' ['20' num2str(text{1,1}(i))] '</data>\n']);
    end
    fprintf(fid,['      <data key="d4">' char(text{1,2}(i)) '</data>\n']);
    fprintf(fid,['    </node>\n']);    
end

FileName = 'Gordon_lh_LUT.txt'
fid2 = fopen(FileName);
text = textscan(fid2,'%d %s %d %d %d %d');
fclose(fid2); clear fid2;
cols = length(text);
rows = size(text{1,1},1);

for i = 2:rows
    node=text{1,1}(i);
    fprintf(fid,['    <node id="' num2str(node) '">\n']);
    if node <10;
        temp='true';
    else
        temp='false';
    end
    fprintf(fid,['      <data key="d0">cortical</data>\n']);
    fprintf(fid,['      <data key="d1">' char(text{1,2}(i)) '</data>\n']);
    fprintf(fid,['      <data key="d2">left</data>\n']);
    if strcmp(temp,'true')
        fprintf(fid,['      <data key="d3">' ['100' num2str(text{1,1}(i))] '</data>\n']);
    else
        fprintf(fid,['      <data key="d3">' ['10' num2str(text{1,1}(i))] '</data>\n']);
    end
    fprintf(fid,['      <data key="d3">' num2str(text{1,1}(i)) '</data>\n']);
    fprintf(fid,['      <data key="d4">' char(text{1,2}(i)) '</data>\n']);
    fprintf(fid,['    </node>\n']);    
end
fprintf(fid,['  </graph>\n']);
fprintf(fid,['</graphml>']);
fclose(fid);

disp('All done!')
    
