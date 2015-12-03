function fcmri_only_corr(ROI_info_file,subject_info_file,R_array)
% This function performs correlation analysis and exports to saved matrix and to sonia for graph display.
%
% Examples:
% A. make developmental timecourse:
%     fcmri_corr('22ROIs_control+cblm_info.txt','210subjects_info.txt','22ROIs_210subjects.mat')
%
%Alex vers: 01.14.08b  -- see body of script for more info and options
%
%This function makes or takes a 3D matrix of corr values (each sheet is an individual,
%in age/list order) and makes sets of average matrices and creates .SON files for Sonia.
%
% ROI_info_file     - a text file with the names and locations of the ROIs, categories, and colors
% subject_info_file - a text file with the vc#s and ages of the subjects
% R_array           - the input/output .mat file, containing the R-matrices, will be created if does not exist (This is the file needed for Frannian analysis)


%% EXAMPLE FILE NAMING CONVENTION: (IF YOU ARE GOING TO RUN THE SCRIPT IN CELL-MODE, UNCOMMENT AND USE THESE LINES TO SET THE FILENAMES):
% ROI_info_file='22ROIs_control+cblm_info.txt';
% subject_info_file='210subjects_info.txt';
% R_array='22ROIs_210subjects_new.mat';

%% FILES AND SETTINGS THIS SCRIPT IS GOING TO USE, CHANGE IF NEEDED, FOR DEV. TIMECOURSE, THRES. DROPPING, STATIC, AND COMPARISON MOVIES
% ======================================================================================================================================
% A ROI_info_file and a subject_info_file must specified for this function, see example files for format.
% Possible colors for nodes and links are: Black DarkGray LightGray White Cyan Green Magenta Orange Pink Red Yellow Blue
% ===================================================================

%% WHERE ARE THE TIMECOURSE FILES WE NEED? NOTE: IF YOU HAVEN'T GONE TO THIS DIRECTORY AND MADE YOUR TIMECOURSES, DO THAT FIRST!


tc_dir='/media/data1/DREADDs/Analyses';



% ======================================================================================================================================
%% Load information about the ROIs and the Subjects:

% Read the ROI_info file:
fid=fopen(ROI_info_file);
ROI_info=textscan(fid,'%d %d%d%d %s %s%s %s%s %s%s','emptyValue',0,'HeaderLines',1,'TreatAsEmpty','na');
fclose(fid);

% Get all the vc numbers and ages:
fid=fopen(subject_info_file);
vc_names=textscan(fid,'%s%f');
fclose(fid);


% Store the ages in a separate file:
ages{1,1}=vc_names{1,2};

%% Do correlation calculation if MAT-file doesn't exist, or just load the file

% Load and perform correlations if needed
if exist(R_array,'file') == 0
    subjects=cell(1,size(vc_names{1,1},1));
    % load the subjects' timecouses:
    for i=1:length(vc_names{1,1}) % for each subject
        for j=1:size(ROI_info{1,1},1) % get each ROI we're interested in
            prefix=[tc_dir '/connectivity_ready_data/' vc_names{1,1}{i,1} '/timecourses/' vc_names{1,1}{i,1} '_' char(ROI_info{1,5}(j,1)) ]; %uncomment for DREMS
            subjects{1,i}(:,j)=single(load([prefix '.dat']));
        end
    end
    % make the correlation output file:
    sz = size(subjects,2);
    subject_array_3D = zeros(size(subjects{1,1},2),size(subjects{1,1},2),size(subjects,2),'single');
    % run corrcoef
    for a = 1:sz
        subject_array_3D(:,:,a) = corrcoef(subjects{a});
    end
    savescript=['save ' R_array ' subject_array_3D'];
    eval(savescript);

    % Otherwise, just load the correlation matrix
elseif exist(R_array,'file') == 2
    subjects=cell(1,size(vc_names{1,1},1));
    % load the dataset
    load(R_array);
end
