%-------------------------------------------------------------------------%
% Script to Generate caret Nodes and Vectors based on input Matrix.
%-------------------------------------------------------------------------%
% - We need to input your matrix file which should be 0 for no connections
%   and 1 or weighted where there is a connection.
% - Then we create a vector file for connections and nodes 
% 	to plot them on a brain using Caret!
%-------------------------------------------------------------------------%
%clean UP!
clear; clc;

%InDir = '/group_shares/FAIR_LAB/Projects/Primate/diet/Analyses/group_analyses/MATLAB_Analyses/';
InDir = 'M:/Projects/Primate/diet/Analyses/group_analyses/MATLAB_Analyses/';

% Specify input files
fMat = 'deficient7_funcMat_LVE00.mat'; %Matrix input File - 2D or 3D matrix;input variable name is "subject_array_3D"
fROIs = 'Both_5mm_Grid_Macaque_F99.txt'; %ROI input File - Both_5mm_Grid_Macaque_F99.txt or LVE00_176_ROIs_Left_Right_Int.txt
fROIs2 = 'Both_5mm_Grid_Macaque_F99_numb.txt'; %ROI input File 2 that uses numbers for colors

fMat_mask = 'adjacencyMask_LVE00.txt'; %for use with LVE00 or PHT00, to threshold out adjacent connections

fMat_lengths = 'GRID867_lengths.mat'; %for use with GRID, to threshold out connection distances < length_thresh

%Specify outputs
stem = 'deficient7_LVE00_adjMASK_4perc';

%Specify type of modularity analyses
finetune = 0; %1 for yes, 0 for no
typemod = 1; % 1 for mean matrix then modularity; 2 for each subject (not done yet for individuals)
othermod = 0; % 1 to include matrix figure of secondary or other modular structure (need mod info below)
fMod_info = 'Functional_modularity_CTL_82_thresh_All_0.0_mod_info.mat';

%Specify thresholds if you want
sFeat = 0; % 1 if you want to use all connections, 2 set threshold, or 0 for set number of features.
threshold = 0.0; %if you want to include a threshold, put it here
percFeat=.04; % percentage of features/connections (0 to 1); 

%Apply adjacency mask?
adj_mask = 1; %yes (1) or no (0)

length_thresh = 65; %(distance in mm) %for use with GRID, to threshold out connection distances < length_thresh

% Specify whether you want to look at positive (0), negative (1), or both (2)
P = 2;

% Load files
load( [InDir, fMat] );
Mat = subject_array_3D;
clear subject_array_3D;

Mask_Mat=load( [InDir, fMat_mask] );
clear subject_array_3D;

load( [InDir, fMat_lengths] );
lengths_Mat = subject_array_3D;
clear subject_array_3D;

[Sx,Sy,M] = size(Mat);

% ind=find(lengths_Mat>length_thresh);
% Mask_Mat=zeros(Sx,Sy);
% Mask_Mat(ind)=1;

% apply adjacency mask
if adj_mask == 1
    for s=1:M
        Mat(:,:,s) = Mat(:,:,s) .* Mask_Mat;
    end
end

% Do you want to look at positive connections or negative connections

if P == 0
    temp1 = mean(Mat,3);
    temp2 = find(temp1 < 0);
    for i = 1:M
        temp3 = Mat(:,:,i);
        temp3(temp2) = 0;
        Mat(:,:,i) = temp3;
    end
    clear temp1 temp2 temp3

    'Testing Positive connections'
elseif P == 1
       temp1 = mean(Mat,3);
    temp2 = find(temp1 > 0);
    for i = 1:M
        temp3 = Mat(:,:,i);
        temp3(temp2) = 0;
        Mat(:,:,i) = temp3;
    end
    clear temp1 temp2 temp3

    'Testing Negative Connections'
elseif P ==2
else
    'P has to equal 2, 1 or 0'
end

% --- Read file that contains information about ROIs like coordinates etc.
fid = fopen( [InDir, fROIs] );
%fid = fopen('test.txt');
ROI_Info = textscan(fid, '%d%d%d%d%s%s%s%s%s%d', 'emptyValue', 0, 'HeaderLines', 1);
ROI_Coords = [ROI_Info{:,2}, ROI_Info{:,3}, ROI_Info{:,4}];

% Create mean matrix
%Mat_mean = mean(Mat,3);

% Apply thresholds if there is one

if sFeat == 1
    Mean_Mat = mean(Mat,3);
    Orig_Mean_Mat = mean(Mat,3);
    Ind_Mat = Mat;
elseif sFeat == 2
    Mean_Mat = mean(Mat,3);
    Orig_Mean_Mat = mean(Mat,3);
    thresh_Ind = find(Mean_Mat < threshold);
    Mean_Mat(thresh_Ind) = 0;
    
    Ind_Mat = Mat;
    thresh_Ind2 = find(Ind_Mat < threshold);
    Ind_Mat(thresh_Ind2) = 0;
elseif sFeat == 0
    Mean_Mat = mean(Mat,3);
    Orig_Mean_Mat = mean(Mat,3);
    
    nFeat=round(percFeat*Sx*(Sx-1)/2);
    [Y,I] = sort(Mean_Mat(:),'descend');
    Mean_Mat(I(2*nFeat+1:end)) = 0;
end 

K=length(find(Mean_Mat))/2

if typemod == 1
    
    if finetune == 1
        [Ci Q] = modularity_finetune_und_sign(Mean_Mat,'sta');
        colors = Ci';
    else
        [Ci Q] = modularity_und(Mean_Mat);
        colors = Ci;
    end
    
    pointsz = ones(Sx,1);
%     Ci_temp = Ci;
%     cc_default = find(Ci == Ci(160));
%     cc_CO = find(Ci == Ci(2));
%     cc_Occ = find(Ci == Ci(25));
%     cc_SM = find(Ci == Ci(15));
%     cc_FP = find(Ci == Ci(41));
%     cc_Cer = find(Ci == Ci(140));
%     if max(Ci) > 6
%         cc_other = find(Ci == 7);
%     else
%     end
%     
%     Ci(cc_CO) = 1;
%     Ci(cc_default) = 2;
%     Ci(cc_Occ) = 3;
%     Ci(cc_FP) = 4;
%     Ci(cc_SM) = 5;
%     Ci(cc_Cer) = 6;
%     if max(Ci) > 6
%         Ci(cc_other) = 7;
%     else
%     end
    
    number_of_modules=max(Ci)
        
    Module_assignments = [stem, '_mod_assign.txt'];
    
    dlmwrite(Module_assignments,colors);
    
%     fFociName = [stem,'.csv.foci']; % set foci file name
%     fFocicolorName = [stem,'.csv.focicolor'];
%     DB_cv_foci_filemaker_ptsize_mod_hold;
    
    figure(1);
    [On Ar] = reorder_mod(Orig_Mean_Mat, colors);
    
    imagesc(Ar, [0 1]); %change scale here if need be
    %imagesc(Ar);
    colormap('hot');colorbar;
    Module_info = [stem, '_mod_info.mat'];
    save(Module_info, 'Ci', 'Q', 'On', 'Ar','colors');
%     figure(2);
%     imshow(Ar);
%     colormap('jet');colorbar;
     if othermod == 1
        figure(2);
        load([InDir, fMod_info]);
        Ar2 = Orig_Mean_Mat(On,On);
        imagesc(Ar2, [0 1]); %change scale here if need be
        %imagesc(Ar);
        colormap('hot');colorbar;
     else
     end
     
    
elseif typemod == 2
%     for i = 1:4 %M
%         %[Ci Q] = modularity_und(Ind_Mat(:,:,i));
%         [Ci Q] = modularity_finetune_und_sign(Ind_Mat(:,:,i),'sta');
%         Q
%         colors = Ci;
%         pointsz = ones(Sx,1);
%         fFociName = [stem,num2str(i),'.csv.foci']; % set foci file name
%         fFocicolorName = [stem,num2str(i),'.csv.focicolor'];
%         DB_cv_foci_filemaker_ptsize_mod_hold
%         
%         figure(i);
%         [On Ar] = reorder_mod(Mat(:,:,i), Ci);
%         imagesc(Ar);
%         colormap('jet');colorbar;
% 
% %         figure(i);
% %         imshow(Ar);
% %         colormap('jet');colorbar;
%     end
end

%%%%remove non-value nodes from picture

