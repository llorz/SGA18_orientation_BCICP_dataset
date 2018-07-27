% map: maps the vertex on S1 to S2
function [cov] = visualize_map_colors_with_error_and_coverage(S1,S2,map,err,para_in)
X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
X2 = S2.surface.X; Y2 = S2.surface.Y; Z2 = S2.surface.Z;
n1 = size(X1,1);
n2 = size(X2,1);

f = zeros(n2,1);
f(unique(map)) = 1;
cov = 100*length(unique(map))/n2; % coverage rate

g1 = S2.surface.X;
g2 = S2.surface.Y;
g3 = S2.surface.Z;

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);

f1 = g1(map);
f2 = g2(map);
f3 = g3(map);



%% overlay parameters
a = 1.5;
overlay_axis = 'y';

if nargin > 4
    if isfield(para_in,'plot')
        para = para_in.plot;
    else
        para = para_in;
    end
    
    if isfield(para,'fig_dist')
        a = para.fig_dist;
    end
    
    if isfield(para,'overlay_axis')
        overlay_axis = para.overlay_axis;
    end
end

xdiam = a*(max(S2.surface.X)-min(S2.surface.X));
ydiam = a*(max(S2.surface.Y)-min(S2.surface.Y));
zdiam = a*(max(S2.surface.Z)-min(S2.surface.Z));

switch overlay_axis
    case 'x'
        ydiam = 0; zdiam = 0;
    case 'y'
        xdiam = 0; zdiam = 0;
    case 'z'
        xdiam = 0; ydiam = 0;
    otherwise
        error('invalid type: overlay_axis')
end


%% visualize the shapes
% error of the map, per vertex on shape S1
trimesh(S1.surface.TRIV, S1.surface.X, S1.surface.Y, S1.surface.Z, ...
    'FaceVertexCData', err, 'FaceColor','interp', 'EdgeColor', 'none'); axis equal;
hold on; axis off;

% source shape
trimesh(S1.surface.TRIV, S1.surface.X + xdiam, S1.surface.Y + ydiam, S1.surface.Z + zdiam, ...
    'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp', 'EdgeColor', 'none','FaceAlpha', 1); axis equal;
hold on; axis off;

% target shape
trimesh(S2.surface.TRIV, S2.surface.X + 2*xdiam, S2.surface.Y + 2*ydiam, S2.surface.Z + 2*zdiam, ...
    'FaceVertexCData', [f.*g1, f.*g2 ,f.*g3], 'FaceColor','interp', 'EdgeColor', 'none','FaceAlpha', 1); axis equal;
hold on; axis off;
% view([0,90])

end