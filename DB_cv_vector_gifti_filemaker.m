%function M_caretfilemaker(name,xyz,rgb,shape,fociname,focicolorname)
%% make gifti vector file
function[] = DB_cv_vector_gifti_filemaker( gifti_vector_name, aa, nodenum, ...
     origin_x, origin_y, origin_z, unitvect_x, unitvect_y, unitvect_z, ...
     normvect, r, g, b, alpha_vect, cx_weights )
 
load template_vector_gii.mat; % load the empty xml template file
%%
%gifti_vector_name = '160_DREMS_05to7_alpha1_01_20_10.vector.gii'; % set the name you want for the vector file
%gifti_vector_name = '39_subjects_connections.vector.gii'; % set the name you want for the vector file
%%
fid=fopen(gifti_vector_name,'wt');
for i =1:46
fprintf(fid,xml_template_text{i});
fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%d\n',nodenum(i,:));
end
for i =48:69
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%d\n',origin_x(i,:));
end
for i =71:92
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%d\n',origin_y(i,:));
end
for i =94:115
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%d\n',origin_z(i,:));
end
for i =117:138
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',unitvect_x(i,:));
end
for i =140:161
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',unitvect_y(i,:));
end
for i =163:184
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',unitvect_z(i,:));
end
for i =186:207
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',normvect(i,:));
end
for i =209:230
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
%--------------------------------------------------------------------------
% for i = 1:aa
%     fprintf(fid,'%6.64f\n',weights_mean_feat_alw_top_200_scaled(i,:));
% end
for i = 1:aa
    fprintf(fid,'%6.64f\n', abs(cx_weights(i,:)));
end
%--------------------------------------------------------------------------
for i =232:253
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',r(i,:));
end
for i =255:276
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',g(i,:));
end
for i =278:299
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%6.64f\n',b(i,:));
end
for i =301:322
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
for i = 1:aa
    fprintf(fid,'%d\n',alpha_vect(i,:));
end
for i =324:326
    fprintf(fid,xml_template_text{i});
    fprintf(fid,'\n');
end
fclose(fid);
%%
