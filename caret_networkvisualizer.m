function[] = caret_networkvisualizer(ROIinfofile,ROIinfofile_int,conmat,modules,stem,colorscheme,NVnodes,matfiles)
%caret_networkvisualizer    makes .csv.foci, .csv.focicolor, and .vector.gii files
%for visualizing nodes and edges in caret
%
%   INPUTS:
%   - ROIinfofile is the standard ROI info file for building FC matrices
%   - conmat is the 2D connectivity matrix
%   - modules should be the 'ci' output of a community detection, i.e. a
%   vector of integers for each node ranging from 1 to n modules.
%   - stem is just the file prefix of the output
%   - colorscheme can be 'rand' or 'hold' - 'hold' will fix the first 14
%   modules to a predefined color scheme and randomize after that. default
%   is 'rand'
%   - NVnodes should be >0 if you want unconnected nodes to still appear;
%   otherwise 0
%   - matfiles is 0 to suppress .mat file output of nodesizes and edges, 1
%   to include them
%
%   EXAMPLE:
%   caret_filemaker('RM_ROI_info_file.txt',RM_SCmat,ci,'RMviz','hold',0,1)
%

%% prepare script
fid = fopen(ROIinfofile);
ROI_Info = textscan(fid, '%d%d%d%d%s%s%s%s%s%d', 'emptyValue', 0, 'HeaderLines', 1);
fclose(fid);
ROI_Coords = [ROI_Info{:,2}, ROI_Info{:,3}, ROI_Info{:,4}];
fGII = [stem,'.vector.gii'];
fVMAT = [stem,'.mat'];
fPointsz = [stem, '.POINTSZ.mat'];

%% Create .foci and .focicolor files
pointsz = strengths_und(conmat);
pointszzero = find(pointsz == 0);
pointsz(pointszzero) = NVnodes;
%write to foci and focicolor files
caretfoci_filemaker(ROIinfofile_int,pointsz,modules,stem,colorscheme)

%% Create vector files for input into cv_convert_vectors_to_gifti
%get x,y,z coordinates of roi pairs
[Sx,Sy] = size(conmat);
lowermat = tril(conmat,-1) + triu(ones(Sx,Sy)*0);
[Y,I] = sort(lowermat(:),'descend' );
Ind = I(find(Y ~= 0));   
[reg1,reg2] = ind2sub( [Sx,Sy], Ind );
n = length(Ind);
c = zeros(n,2,3);
c(:,1,:) = ROI_Coords(reg1,:);  % Coordinates of ROI1
c(:,2,:) = ROI_Coords(reg2,:);  % Coordinates of ROI2
%get weights of corresponding roi pairs
cx_weights = conmat(Ind);
%write to gii file
DB_cv_convert_vectors_to_gifti( c, n, cx_weights, fGII);

%% save .mat files
if exist('matfiles','var') && matfiles
    save(fPointsz, 'pointsz');
    save(fVMAT, 'c');
end