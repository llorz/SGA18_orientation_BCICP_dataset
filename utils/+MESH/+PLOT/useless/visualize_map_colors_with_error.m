% map: maps the vertex on S1 to S2
function [] = visualize_map_colors_with_error(S1,S2,map,err,para,samples)
g1 = S2.surface.X;
g2 = S2.surface.Y;
g3 = S2.surface.Z;

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);

f1 = g1(map);
f2 = g2(map);
f3 = g3(map);

X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
X2 = S2.surface.X; Y2 = S2.surface.Y; Z2 = S2.surface.Z;

%% overlay parameters
a = 1.5;
overlay_axis = 'z';

if nargin > 4
    if isfield(para,'plot')
        if isfield(para.plot,'fig_dist')
            a = para.plot.fig_dist;
        end
        if isfield(para.plot,'overlay_axis')
            overlay_axis = para.plot.overlay_axis;
        end
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
    'FaceVertexCData', [g1 g2 g3], 'FaceColor','interp', 'EdgeColor', 'none','FaceAlpha', 1); axis equal;
hold on; axis off;

%% visualize the sample correspondences 
if nargin < 6
    samples = find(err > quantile(err,1));
elseif (length(samples) == 1) && (samples <=1) && (samples >= 0) % input samples is a quantile
    samples = find(err > quantile(err,samples));
end

if (~isempty(samples))
    target_samples = map(samples);
    
    Xstart = X1(samples)'; Xend = X2(target_samples)';
    Ystart = Y1(samples)'; Yend = Y2(target_samples)';
    Zstart = Z1(samples)'; Zend = Z2(target_samples)';

    Xstart = Xstart + xdiam; Xend = Xend + 2*xdiam;
    Ystart = Ystart + ydiam; Yend = Yend + 2*ydiam;
    Zstart = Zstart + zdiam; Zend = Zend + 2*zdiam;
    Colors = [f1 f2 f3];
    ColorSet = Colors(samples,:);
    set(gca, 'ColorOrder', ColorSet);
    plot3([Xstart; Xend], [Ystart; Yend], [Zstart; Zend]);
end

end