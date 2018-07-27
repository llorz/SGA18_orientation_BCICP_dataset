function [] = plot_mesh_patches(S,region_in,ifplot)
get_region_indicator = @(seg_id) cellfun(@(i) seg_id == i, num2cell(unique(seg_id)),'UniformOutput',false);
if iscell(region_in)
    if size(region_in,2) == 1
        region = region_in';
    elseif size(region_in,1) == 1
        region = region_in;
    end
else % input is a vector: region id
    region = get_region_indicator(region_in)';
end
base_col = ...
    [102   194   165;
    252   141    98;
    141   160   203;
    231   138   195;
    166   216    84;
    255   217    47;
    229   196   148;
    179   179   179]/255;

base_col = [0.2 0.2 0.2 % Very dark gray = no match
          0.55 0.33 0.7;
          0.80 0.70 0.45;   %0.88 0.86 0.45;
          0.5 0.8 0.45;
          0.35 0.45 1;
          1 0.55 0.3;
          1 0.3 0.5;
          0.2 0.6 0.8;
          0.2 0.8 0.5;
          0.65 0.2 0.2;
          0.47 0.78 0.7;
          0.5 0.5 0.5;
          0.95 0.65 0.8;
          0.1 0.5 0.1;
          0.5 0.2 0.3;
          0.1 0.1 0.5;
          0.1 0.4 0.4;
          0.4 0.4 0.1;
          0.4 0.1 0.4;
          0.75 0.75 0.75;
          0.9 0.9 0.1;
          0.1 0.9 0.1;
          0.1 0.1 0.9;
            1 0.6 0.6;   % light red
            0.6 1 0.6;   % light green
            0.6 0.6 1;   % light blue
            0.5 0.1 0.1; % dark red
            0.1 0.5 0.1; % dark green
            0.1 0.1 0.5; % dark blue
            1 0.8 0.5;   % orange?
            0.6 0.5 0;   % brown?
            0.7 0.3 1;   % purple?
            0.7 0.7 0.7; % light gray% % [x, ~] = eigs(Aff, 1);
            0.4 0.4 0.4; % dark gray
          0.9 0.1 0.1; % red
            0.1 0.9 0.1; % green% % [x, ~] = eigs(Aff, 1);
            0.1 0.1 0.9; % blue
            1.0 1.0 0.0;       % yellow
            0.0 1.0 1.0;       % cyan
            1.0 0.0 1.0;       % magenta
            0.24 0.53 0.66; % random 1
            0.04 0.69 0.3;  % random 2
            0.9 0.4 0.67;   % random 3
            0.4 0.5 0.6];     % random 4



num_base_col = size(base_col,1);
c_id = sum(cell2mat(cellfun(@(i,f) i*f,num2cell(1:length(region)),region,'UniformOutput',false)),2);

% generate colors: convex combinations of the base colors
% num_patch = length(region);
% if num_patch <= num_base_col
%     v_col = base_col(c_id,:);
% else
%     tmp = rand(num_patch - num_base_col,num_base_col);
%     new_base_col = [eye(num_base_col);tmp./sum(tmp,2)]*base_col;
%     v_col = new_base_col(c_id,:);
% end

v_col = base_col(mod(c_id,num_base_col)+1,:);
trimesh(S.surface.TRIV, S.surface.X, S.surface.Y, S.surface.Z,'FaceVertexCData',v_col,...
    'FaceColor','flat', 'EdgeColor', 'none','FaceAlpha',0.95); axis equal; axis off;

if nargin > 2
    figure;
    for i = 1:length(region)
        subplot(2,ceil(length(region)/2),i); plot_func_on_mesh(S,region{i}); title(num2str(i));
    end
end
end