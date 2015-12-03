function[] = caretfoci_filemaker(ROIinfofile,pointsz,modules,outfilename,colorscheme)
%caretfoci_filemaker    Script to create '.foci' and '.focicolor' files for Caret
%
%   caretfoci_filemaker(ROIinfofile,pointsz,modules,outfilename,colorscheme)
%   
%   Inputs:
%   - ROIinfofile is the standard ROI info file for building FC matrices
%   - pointsz is a vector of node sizes
%   - modules should be the 'ci' output of a community detection, i.e. a
%   vector of integers for each node ranging from 1 to n modules.
%   - outfilename is just the file prefix of the output
%   - colorscheme can be 'rand' or 'hold' - 'hold' will fix the first 14
%   modules to a predefined color scheme and randomize after that. default
%   is 'rand'
%   

%% Read information relating to different ROIs
fid=fopen(ROIinfofile);
roi_info = textscan(fid, '%d%d%d%d%s%d%s%d%s', 'emptyValue', 0, 'HeaderLines', 1 );
%roi_info = textscan(fid, '%d%d%d%d%s%s%s%s%s', 'emptyValue', 0, 'HeaderLines', 1 );
fclose(fid);
colors=modules;
fFociName=[outfilename '.csv.foci'];
fFocicolorName=[outfilename '.csv.focicolor'];

% ROI Numbers & Coordinates
cn = [roi_info{:,1}, roi_info{:,2}, roi_info{:,3}, roi_info{:,4}];
% ROI Names
name = roi_info{:,5};
% ROI Sides
side = cell(size(cn,1),1);
for i=1:size(cn,1)
    if cn(i,2) > 0
        side{i} ='right'; % writing the left/right hemisphere labels
    else
        side{i}='left';
    end
end

%% Make foci file from ROI locations
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

%% set different colors for different modules
num_mods = max(colors);
for j=1:num_mods
    module_rgb{j} = [rand * 255 rand * 255 rand * 255]; %
end
if exist('colorscheme','var') && strcmp(colorscheme,'hold')
    module_rgb{1} = [0 0 0]; % Cinguloopercular - Black
    module_rgb{2} = [255 0 0]; % default - Red
    module_rgb{3} = [0 190 190]; % sensorimotor -  Cyan
    module_rgb{4} = [200 200 0]; % FP - Yellow
    module_rgb{5} = [0 190 0]; % occipital - Green
    module_rgb{6} = [0 0 190]; % sup cerebellum - Blue
    module_rgb{7} = [0 0 50]; % Cinguloopercular - Black %%%%
    module_rgb{8} = [190 0 50]; % default - Red
    module_rgb{9} = [0 190 50]; % occipital - Green
    module_rgb{10} = [255 255 50]; % FP - Yellow
    module_rgb{11} = [50 190 190]; % sensorimotor -  Cyan
    module_rgb{12} = [50 0 190]; % sup cerebellum - Blue
    module_rgb{13} = [50 0 50]; % Cinguloopercular - Black
    module_rgb{14} = [190 50 50]; % default - Red
end

for i=1:size(cn,1)
    mod_rgb(i,:) = module_rgb{colors(i)};
end
%%
shape = cell(size(cn,1),1);
for i =1:size(cn,1)
    shape{i} = 'SPHERE';  % Can be POINT, SQUARE, NONE, etc.
end
%%
% Can change these settings in Caret later too!
alpha=255;
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
    %pointsize=2; %if you want to fix nodesize
    fprintf(fid,'%s,%d,%d,%d,%d,%6.64f,%d,%s,,\n',name{i},mod_rgb(i,1),mod_rgb(i,2),mod_rgb(i,3),alpha,pointsize,linesize,shape{i,1});
end

fprintf(fid,'csvf-section-end,Colors,,,,,,,,');
fclose(fid);
%%