clear all
clc
% 
% 
 ROI_info_file='Both_5mm_Grid_Macaque_F99.txt';
 subject_info_file= 'deficient_subs.txt';
 R_array='deficient7_funcMat_GRID867.mat';%correlation output
  focus_group='all';
rem_timecourse='deficient7_funcMat_GRID867_rem.mat'; % remaining frames
 param='deficient7_funcMat_GRID867_param.mat';
FD_thres=0.2;

% function fcmri_corr_FD_removal_all(ROI_info_file,subject_info_file,R_array,focus_group,movietype,son_name,rem_timecourse,param)
% This function performs correlation analysis and exports to saved matrix and to sonia for graph display.
%
% Examples:
% A. make developmental timecourse:
%     fcmri_corr('22ROIs_control+cblm_info.txt','210subjects_info.txt','22ROIs_210subjects.mat','all','dev','22ROIs_210subjects_dev_pt15.son')
% B. make threshold dropping movie for adults only:
%     fcmri_corr('22ROIs_control+cblm_info.txt','210subjects_info.txt','22ROIs_210subjects.mat','adults','thres','22ROIs_40adults_thres_pt60_pt05.son')
%
%Alex vers: 01.14.08b  -- see body of script for more info and options
%
%This function makes or takes a 3D matrix of corr values (each sheet is an individual,
%in age/list order) and makes sets of average matrices and creates .SON files for Sonia.
%
% ROI_info_file     - a text file with the names and locations of the ROIs, categories, and colors
% subject_info_file - a text file with the vc#s and ages of the subjects
% R_array           - the input/output .mat file, containing the R-matrices, will be created if does not exist (This is the file needed for Frannian analysis)
% focus_group       - determines which subset of subjects will be used ('all','kids','adults','control','exp')
% movietype         - determines whether you want a developmental timecourse, threshold dropping, or static movie ('dev','thres','static')
% son_name          - the output file that will be used in Sonia.


%% EXAMPLE FILE NAMING CONVENTION: (IF YOU ARE GOING TO RUN THE SCRIPT IN CELL-MODE, UNCOMMENT AND USE THESE LINES TO SET THE FILENAMES):
% ROI_info_file='22ROIs_control+cblm_info.txt';
% subject_info_file='210subjects_info.txt';
% R_array='22ROIs_210subjects_new.mat';
% focus_group='adults';
% movietype='thres';
% son_name='22ROIs_40adults_thres_pt60_pt05_new.son';

%% FILES AND SETTINGS THIS SCRIPT IS GOING TO USE, CHANGE IF NEEDED, FOR DEV. TIMECOURSE, THRES. DROPPING, STATIC, AND COMPARISON MOVIES
% ======================================================================================================================================
% A ROI_info_file and a subject_info_file must specified for this function, see example files for format.
% Possible colors for nodes and links are: Black DarkGray LightGray White Cyan Green Magenta Orange Pink Red Yellow Blue
% ===================================================================

%% WHERE ARE THE TIMECOURSE FILES WE NEED? NOTE: IF YOU HAVEN'T GONE TO THIS DIRECTORY AND MADE YOUR TIMECOURSES, DO THAT FIRST!
tc_dir='M:\Projects\Primate\diet\Analyses\unknown'; % PC
%tc_dir='/group_shares/FAIR_LAB/Projects/Primate/diet/Analyses/unknown'; %AIRC

% ===================================================================


% Get all the vc numbers and ages:
fid=fopen(subject_info_file);
vc_names=textscan(fid,'%s%f');
fclose(fid);


% WHO SHOULD WE LOOK AT THIS TIME?

% Which set of subjects should be used to generate average matrices? (currently can be 1,2,or3)

    % Use everyone (for dev. movies, or if your subject_info_file is homogeneous)
if isequal(focus_group,'all')
    group=1:length(vc_names{1,1});
    
    % Just the kids
elseif isequal(focus_group,'kids')
    group=1:40;
    
    % Just the adults
elseif isequal(focus_group,'adults')
    group=171:210;
    
    % Group 1 (Control)
elseif isequal(focus_group,'control')
    group=1:13;
    
    % Group 2 (Experimental)
elseif isequal(focus_group,'exp')
    group=1:24;
end

% ===================================================================

% WHAT THRESHOLD(S) SHOULD WE USE?

% For developmental, static, or between group comparisions
static_threshold=0.15;

% For X skip Y movies, this is X; otherwise doesn't matter
groupsize=15;
% For X skip Y movies, this is Y; otherwise doesn't matter
stepsize=1;

% For threshold dropping movies
dropping_threshold=[.60:-.01:.15 .15 .15 .15 .15 .14:-.01:.05];

% ===================================================================

% WHAT CATEGORY DO WE WANT THE COLORS TO REPRESENT?

% Which of the three columns should we use for the colors? (currently can be A, B, or C)
color_source='C';
% Which of the three columns should we use for border colors? (if you don't want borders, set to zero)
border_source=0; % i.e.  =0;  or  ='B';
% How wide do you want the border to be? (you just have to play with it, 3 is thinish, 5 is thickful)
border_width=3;
% What color do you want the lines to be? (Possible colors are the same as for the nodes, see comments at top)
arc_color='Black'; 

% ===================================================================

% SHOULD WE SHOW CLUSTERS OR HIGHLIGHT NODES?

% Which of the three columns should we use for clustering? (currently can be A, B, or C, or zero for no clusters)
cluster_source=0;
% What are the names of the clusters you want me to cluster? (don't pick too many, and the names must match the ROI_info file)
cluster_names={'Cingulo_Opercular','Fronto_Parietal','Cerebellum'}; % i.e. ={'Cingulo-Opercular','Fronto-Parietal','Cerebellum'};

% The start and stop time of the clusters can be modified in the .son file relatively easily...

% ======================================================================================================================================
%% Load information about the ROIs and the Subjects:

% Read the ROI_info file:
fid=fopen(ROI_info_file);
ROI_info=textscan(fid,'%d %d%d%d %s %s%s %s%s %s%s','emptyValue',0,'HeaderLines',1,'TreatAsEmpty','na');
fclose(fid);



% Store the ages in a separate file:
ages{1,1}=vc_names{1,2};

FD_plot=ones(600,length(group));
    

for i=1:length(vc_names{1,1}) % for each subject\
%  for i=5
    %Finding the number of skip and the 
    i
    sub_name=vc_names{1,1}{i,1};
    age=vc_names{1,2};
    
%%%%%%%%%%%%%%%%%Getting the number of skips and run for each subject%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    clear abc
    clear text
    prefix_1=[tc_dir '/connectivity_ready_data/' vc_names{1,1}{i,1} '/' vc_names{1,1}{i,1} '.params'];
    abc=fopen(prefix_1);

    text=textscan(abc,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n');
    a=text{1,4}{21,1};
    bc=0;
    k=4;
    for j=1:4
        if strcmp(text{1,k}{10,1},'#')==0
            bc=bc+1;
        else
            break
        end
        k=k+1;
    end
    
    skip=str2num(a)+1;
    run=bc;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Getting the timecourse for each subject%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for j=1:size(ROI_info{1,1},1) % get each ROI we're interested in
       roc_prefix=[tc_dir '/connectivity_ready_data/' vc_names{1,1}{i,1} '/timecourses/' vc_names{1,1}{i,1} '_' char(ROI_info{1,5}(j,1)) ]; %uncomment for DREMS
        subjects_temp{1,i}(:,j)=single(load([roc_prefix '.dat']));
        subjects{1,i}(:,j)=single(load([roc_prefix '.dat']));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
    clear run_num
    if run==1
        f=1;
        temp_run=text{1,4}(10,1);
        temp_run=char(temp_run);
        run_num(f,1)=str2num(temp_run(2));
    elseif run==2
        for f=1:run
            if f==1
            temp_run=text{1,4}(10,1);
            temp_run=char(temp_run);
            run_num(f,1)=str2num(temp_run(2));
            else
                temp_run=text{1,5}(10,1);
                temp_run=char(temp_run);
                run_num(f,1)=str2num(temp_run(1));
            end
        end
    elseif run==3
        for f=1:run
            if f==1
                temp_run=text{1,4}{10,1};
                temp_run=char(temp_run);
                run_num(f,1)=str2num(temp_run(2));
            elseif f==2
                run_num(f,1)=str2num(char(text{1,5}(10,1)));
            elseif f==3
                temp_run=text{1,6}(10,1);
                temp_run=char(temp_run);
                run_num(f,1)=str2num(temp_run(1));
            end
        end
    end
    


run_num
               
        

%removing the frames above 0.5
            
    clear FD         
    for s=1:run  
%          prefix=['W:\NIGG\Analyses\Pilot\processed_data\' vc_names{1,1}{i,1} '/movement/' vc_names{1,1}{i,1} '_b' num2str(run_num(s,1)) '_faln_dbnd_xr3d.dat']
         prefix=[tc_dir '/processed_data/' vc_names{1,1}{i,1} '/bold1/' vc_names{1,1}{i,1} '_b' num2str(run_num(s)) '_faln_dbnd_xr3d.dat'];

        %Finding the index for the footer text
        clear motion1

        fid=fopen(prefix);
        motion1=textscan(fid,'%s%s%s%s%s%s%s%s','HeaderLines',3);
        val=strcmp(motion1{1,1},'#counting');
        fclose(fid);

        M=find(val==1);
        N=M-1

        %loading the dat file into matlab

        fid=fopen(prefix);
        motion=textscan(fid,'%d%f%f%f%f%f%f%f', N,'HeaderLines',3);
        fclose(fid);

        %Converting the rotation into mm

        x_rot=(50*pi/180)*(motion{1,5});
        y_rot=(50*pi/180)*(motion{1,6});
        z_rot=(50*pi/180)*(motion{1,7});

        % x=mean(motion{1,2});
        % y=mean(motion{1,3});
        % z=mean(motion{1,4});
        % rot_x=mean(x_rot);
        % rot_y=mean(y_rot);
        % rot_z=mean(z_rot);

        clear diff_x
        clear diff_y
        clear diff_z
        clear rot_diff_x
        clear rot_diff_y
        clear rot_diff_z

        for b=2:N
            diff_x(b-1)=motion{1,2}(b-1)-motion{1,2}(b);
            diff_y(b-1)=motion{1,3}(b-1)-motion{1,3}(b);
            diff_z(b-1)=motion{1,4}(b-1)-motion{1,4}(b);
            rot_diff_x(b-1)=x_rot(b-1)-x_rot(b);
            rot_diff_y(b-1)=y_rot(b-1)-y_rot(b);
            rot_diff_z(b-1)=z_rot(b-1)-z_rot(b);
        end

        % clear FD
        clear FD_dim
        
        
        FD(:,s)=abs(diff_x)+abs(diff_y)+abs(diff_z)+abs(rot_diff_x)+abs(rot_diff_y)+abs(rot_diff_z);
%         FD_save(:,s,i)= abs(diff_x)+abs(diff_y)+abs(diff_z)+abs(rot_diff_x)+abs(rot_diff_y)+abs(rot_diff_z);
        FD_temp=FD(:,s);
        FD_temp(1:skip-1,:)=[];
        FD_mean(:,s,i)=mean(FD_temp);
        %             prefix=[tc_dir '/processed_data/' dir '/' sub '/movement/' sub '_b' s '_faln_dbnd_xr3d.dat'];
        FD_dim=find(FD(skip:length(FD),s)>FD_thres)
        length(FD_dim);
        find(FD>FD_thres);
        FD_old=FD;
%         for lp=1:length(FD_dim)
%                 xyz=FD_dim(lp)+skip-1;
%                 FD(xyz,s)=1;
%         end

%         if s==1
%             new_x=motion{1,2};
% 
%         else
%             new_x=[new_x;motion{1,2}];
%         end 

        if s==1
            for m = 1:length(FD_dim)
                if FD_dim(m) == 1
                    subjects{1,i}(1:3,:)=99;
                else
                    if FD_dim(m) == length(FD)-skip
                        n = FD_dim(m)-1;
                        subjects{1,i}(n:n+2,:)=99;
                    elseif FD_dim(m) == length(FD)-skip+1
                        n = FD_dim(m)-1;
                        subjects{1,i}(n:n+1,:)=99;
                    else
                        n = FD_dim(m)-1;
                        subjects{1,i}(n:n+3,:)=99;
                    end
                end
            end
        elseif s==2
            xx=length(FD)-skip+1;
            for m = 1:length(FD_dim)
                if FD_dim(m) == 1
                    subjects{1,i}(xx+1:xx+3,:)=99;
                else
                    if FD_dim(m) == length(FD)-skip
                        n = FD_dim(m)-1;
                        subjects{1,i}(xx+n:xx+n+2,:)=99;
                    elseif FD_dim(m) == length(FD)-skip+1
                        n = FD_dim(m)-1;
                        subjects{1,i}(xx+n:xx+n+1,:)=99;
                    else
                        n = FD_dim(m)-1;
                        subjects{1,i}(xx+n:xx+n+3,:)=99;
                    end
                end
            end
        elseif s==3
            for m = 1:length(FD_dim)
                yy=2*(length(FD)-skip+1);
                if FD_dim(m) == length(FD)-skip | FD_dim(m) == length(FD)-skip-1
                    continue
                end
                if FD_dim(m) == 1
                    subjects{1,i}(yy+1:yy+3,:)=99;
                else
                    if FD_dim(m) == length(FD)-skip
                        n = FD_dim(m)-1;
                        subjects{1,i}(yy+n:yy+n+2,:)=99;
                    elseif FD_dim(m) == length(FD)-skip+1
                        n = FD_dim(m)-1;
                        subjects{1,i}(yy+n:yy+n+1,:)=99;
                    else
                        n = FD_dim(m)-1;
                        subjects{1,i}(yy+n:yy+n+3,:)=99;
                    end
                end
            end
         end
    end
    
    clear templt
    
    templt = zeros(length(subjects{1,i}(:,1)),1);
        
     sub_rem = find(subjects{1,i}(:,1) == 99);
    subjects{1,i}(sub_rem,:)=[];
    
    templt(sub_rem,1)=1;
    
    for s = 1:run
        if s ==1
            for nn = 1:skip
                templt = vertcat(1, templt);
            end
        elseif s ==2
            for nn = 1:skip
                templt = vertcat(templt(1:xx+skip),1,templt(xx+skip+1:end));
            end
        elseif s == 3
            for nn = 1:skip
                templt = vertcat(templt(1:yy+skip),1,templt(yy+skip+1:end));
            end
        end
    end
    
    h=0;
    t=1;
   
    for nn = 2:length(templt)
        if templt(nn) == templt(nn-1)
            h=h+1;
        else
            format{1,i}(t)=h+1;
            t=t+1;
            h=0;
        end
    end
            
    
    %%%%% FD after removing the frames%%%%%%%
            
    if run==1
        f=1;
        for d=skip:length(FD)
            FD_plot(f,i)=FD(d,1);
            f=f+1;
        end
    elseif run==2
        f=1
        for d=1:2
            for e=skip:length(FD)
                FD_plot(f,i)=FD(e,d);
                f=f+1;
            end
        end
    elseif run==3
        f=1
        for d=1:3
            for e=skip:length(FD)
                FD_plot(f,i)=FD(e,d);
                f=f+1;
            end
        end
    end
    
    FD_plot(sub_rem,i)=1;

age=age';
total=run*(N-skip);   
frames(i)=length(subjects{1,i}(:,1));    
percent(i)=((total-frames(i))/total)*100;
wic_frame{i}=sub_rem;
end

% % make the correlation output file:
sz = size(subjects,2);
subject_array_3D = zeros(size(subjects{1,1},2),size(subjects{1,1},2),size(subjects,2),'single');

%run corrcoef
for a = 1:sz
    subject_array_3D(:,:,a) = corrcoef(subjects{a});
end
savescript=['save ' R_array ' subject_array_3D'];
eval(savescript);
%  
save(param,'age','percent','FD_plot','FD_mean','wic_frame')
save(rem_timecourse,'subjects');