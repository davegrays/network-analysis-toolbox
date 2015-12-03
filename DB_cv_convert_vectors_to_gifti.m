%% code for converting vectors in matlab format into gifti vector format needed by Caret
% c cotains ROI pairs in a 3D matrix such that column one has coordinates for 1st ROI in pair and column two has coordinates for 2nd ROI in pair
% x, y, z are stacked in the third dimension
%%
% aa = 143 % set the number of ROI-ROI pairs ... or number of vectors
%%
function[] = DB_cv_convert_vectors_to_gifti( c, aa, cx_weights, gifti_vector_name )

for k = 1:aa
    for kk = 1:3
        origin(k,kk) = c(k,2,kk);
        vect(k,kk) = c(k,1,kk) - c(k,2,kk);
    end
end
%%
for k = 1:aa
    normvect(k,:) = norm(vect(k,:));
    unitvect(k,:) = vect(k,:)/normvect(k,:);
end
%% make all the lists needed for the gifti file
%% node number list
nodenum = (1:aa)';
%% origins
origin_x = origin(:,1);
origin_y = origin(:,2);
origin_z = origin(:,3);
%% unit vectors
unitvect_x = unitvect(:,1);
unitvect_y = unitvect(:,2);
unitvect_z = unitvect(:,3);
%% magnitude
normvect;
%% radius
%weights_mean_feat_alw_top_200_scaled; % if you want to scale thickness of vectors by some weight load here
%% RGB
% set rgb values for vectors
rgb_up =[0 0 .8];
rgb_down =[.8 0 0];
%
for k =1:aa
    if cx_weights(k) > 0 % uses vector 'weights' that contains t-statistics 
        rgb(k,:) = rgb_up; % Blue
    else
        rgb(k,:) = rgb_down; % Red
    end
end
r = rgb(:,1);
g = rgb(:,2);
b = rgb(:,3);
%% alpha
alph = 1; % set alpha
%%
alpha_vect = alph.*(ones(aa,1));
%%

% make gifti vector file
DB_cv_vector_gifti_filemaker( gifti_vector_name, aa, nodenum, ...
     origin_x, origin_y, origin_z, unitvect_x, unitvect_y, unitvect_z, ...
     normvect, r, g, b, alpha_vect, cx_weights );