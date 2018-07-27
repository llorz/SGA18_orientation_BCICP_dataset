% id1: the vertices/landmarks ID on shape S1
% id2: the vertices/landmarsk ID on shape S2
% T_in: a set(cell) of maps (from S1 -> S2) to visualize
function [] = visualize_map_colors_with_symmetricMap(S1,S2,T_in,varargin)
% plot two mesh in the same coordinate
default_param = load_MeshMapPlot_default_params();
param = parse_MeshMapPlot_params(default_param, varargin{:});
X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
X2 = S2.surface.X; Y2 = S2.surface.Y; Z2 = S2.surface.Z;

% set up the overlay direction and distance
xdiam = param.MeshSepDist*(max(S2.surface.X)-min(S2.surface.X));
ydiam = param.MeshSepDist*(max(S2.surface.Y)-min(S2.surface.Y));
zdiam = param.MeshSepDist*(max(S2.surface.Z)-min(S2.surface.Z));
[xdiam, ydiam, zdiam] = set_overlay_axis(xdiam, ydiam, zdiam, param.OverlayAxis);
%%
g1 = S2.surface.X;
g2 = S2.surface.Y;
g3 = S2.surface.Z;

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);


num_T = length(T_in);
for iT = 1:num_T
    map = T_in{iT};
    if sum(isnan(map)) == 0
        f1 = g1(map);
        f2 = g2(map);
        f3 = g3(map);
    else
        nan_id = find(isnan(map));
        id = find(~isnan(map));
        f1(nan_id) = 0.1; f2(nan_id) = 0.1; f3(nan_id) = 0.1;
        f1(id) = g1(map(id));
        f2(id) = g2(map(id));
        f3(id) = g3(map(id));
        f1 = reshape(f1,[],1);
        f2 = reshape(f2,[],1);
        f3 = reshape(f3,[],1);
    end
    trimesh(S1.surface.TRIV, X1+(iT-1)*xdiam, Y1+(iT-1)*ydiam, Z1+(iT-1)*zdiam, ...
        'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp',...
        'FaceAlpha',0.99 , 'EdgeColor', 'none'); view(param.CameraPos);
    axis equal; hold on; axis off;
end

trimesh(S2.surface.TRIV , X2 + num_T*xdiam, Y2 + num_T*ydiam, Z2 + num_T*zdiam, ...
    'FaceVertexCData', [g1 g2 g3], 'FaceColor','interp',...
    'FaceAlpha',0.99, 'EdgeColor', 'none');view(param.CameraPos);
axis equal; axis off;


hold off;
end
