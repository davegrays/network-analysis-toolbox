%-------------------------------------------------------------------------%
% Script to create '.foci' and '.focicolor' files for Caret
%-------------------------------------------------------------------------%

%% Read information relating to different ROIs
fid=fopen(fROIs2);
roi_info = textscan(fid, '%d%d%d%d%s%d%s%d%s', 'emptyValue', 0, 'HeaderLines', 1 );
fclose(fid);

%%
% ROI Numbers & Coordinates
cn = [roi_info{:,1}, roi_info{:,2}, roi_info{:,3}, roi_info{:,4}];
%%
% ROI Names
name = roi_info{:,5};
%%
% ROI ColorCodes
%colors = roi_info{:,6};

%%
% ROI Sides
side = cell(size(cn,1),1);
for i=1:size(cn,1)
    if cn(i,2) > 0
        side{i} ='right'; % writing the left/right hemisphere labels
    else
        side{i}='left';
    end
end
%%
%% Make foci file from ROI locations
%fFociName = 'DREMS_CTRL_vs_COMB_7-14_pos_and_neg_fdr_ptsize_zscore.csv.foci'; % set foci file name
%fFociName = 'DREMS_160_ROIs_262CTRL_Age_correl_pos_and_neg_top200_ptsize_zscore.csv.foci'; % set foci file name
%%
% Write .foci file!!
fid=fopen(fFociName,'wt');
fprintf(fid,'CSVF-FILE,0,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'csvf-section-start,header,3,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'tag,value,,,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'caret-version,5.51,,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'date,Tue Oct 2 15:58:38 2007,,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'encoding,COMMA_SEPARATED_VALUE_FILE,,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'csvf-section-end,header,,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'csvf-section-start,Cells,15,,,,,,,,,,,,,,,,,\n');
fprintf(fid,'Cell Number,X,Y,Z,Section,Name,Study Number,Geography,Area,Size,Statistic,Comment,Structure,Class Name,Study Pubmed ID,Study Table Number,Study Table Subheader,Study Figure Number,Study Figure Panel,Study page Number\n');

for i=1:size(cn,1)
    fprintf(fid,'%d,%d,%d,%d,0,%s,1,,,%f,,,%s,,0\n',i,cn(i,2),cn(i,3),cn(i,4),name{i,1},cn(i,1),side{i}); % contains the xyz etc.
end

fprintf(fid,'csvf-section-end,Cells,,,,,,,,,,,,,');
fclose(fid);
%%

%% Make focicolor file - all foci same size but different colors
%fFocicolorName = 'DREMS_CTRL_vs_COMB_7-14_pos_and_neg_fdr_ptsize_zscore.csv.focicolor'; 
%fFocicolorName = 'DREMS_160_ROIs_262CTRL_Age_correl_pos_and_neg_top200_ptsize_zscore.csv.focicolor';
%% 

%% set different colors for different modules
num_mods = max(colors);
for j=1:num_mods
    module_rgb{j} = [randint(1,1,255) randint(1,1,255) randint(1,1,255)];
end
% module_rgb{1} = [0 0 0]; % Cinguloopercular - Black
% module_rgb{2} = [190 0 0]; % default - Red
% module_rgb{3} = [0 190 0]; % occipital - Green
% module_rgb{4} = [255 255 0]; % FP - Yellow
% module_rgb{5} = [0 190 190]; % sensorimotor -  Cyan
% module_rgb{6} = [0 0 190]; % sup cerebellum - Blue
% module_rgb{7} = [0 0 50]; % Cinguloopercular - Black %%%%
% module_rgb{8} = [190 0 50]; % default - Red
% module_rgb{9} = [0 190 50]; % occipital - Green
% module_rgb{10} = [255 255 50]; % FP - Yellow
% module_rgb{11} = [50 190 190]; % sensorimotor -  Cyan
% module_rgb{12} = [50 0 190]; % sup cerebellum - Blue
% module_rgb{13} = [50 0 50]; % Cinguloopercular - Black
% module_rgb{14} = [190 50 50]; % default - Red

%%

for i=1:size(cn,1)
    mod_rgb(i,:) = module_rgb{colors(i,1)};
end
%%
shape = cell(size(cn,1),1);
for i =1:size(cn,1)
    shape{i} = 'SPHERE';  % Can be POINT, SQUARE, NONE, etc.
end
%%
% Can change these settings in Caret later too!
alpha=255;
%pointsize=2.5;
linesize=1;
%%
% Write .focicolor file!!
fid=fopen(fFocicolorName, 'wt');
fprintf(fid,'CSVF-FILE,0,,,,,,,,\n');
fprintf(fid,'csvf-section-start,header,3,,,,,,,\n');
fprintf(fid,'tag,value,,,,,,,,\n');
fprintf(fid,'caret-version,5.51,,,,,,,,\n');
fprintf(fid,'comment,[Enter comment],,,,,,,,\n');
fprintf(fid,'date,[Enter date],,,,,,,,\n');
fprintf(fid,'encoding,COMMA_SEPARATED_VALUE_FILE,,,,,,,,\n');
fprintf(fid,'pubmed_id,,,,,,,,,\n');
fprintf(fid,'csvf-section-end,header,,,,,,,,\n');
fprintf(fid,'csvf-section-start,Colors,9,,,,,,,\n');
fprintf(fid,'Name,Red,Green,Blue,Alpha,Point-Size,Line-Size,Symbol,,\n');

for i=1:size(cn,1)
    pointsize=pointsz(i);
    %pointsize=2;
    fprintf(fid,'%s,%d,%d,%d,%d,%6.64f,%d,%s,,\n',name{i},mod_rgb(i,1),mod_rgb(i,2),mod_rgb(i,3),alpha,pointsize,linesize,shape{i,1});
end

fprintf(fid,'csvf-section-end,Colors,,,,,,,,');
fclose(fid);
%%