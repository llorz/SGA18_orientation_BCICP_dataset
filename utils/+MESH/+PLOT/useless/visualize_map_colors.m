% id1: the vertices/landmarks ID on shape S1
% id2: the vertices/landmarsk ID on shape S2
function [] = visualize_map_colors(S1,S2,map,para_in,id1,id2)
% plot two mesh in the same coordinate
a = 1.5;
overlay_axis = 'y';

if nargin > 3
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
        error('invalid overlay_axis type')
end
%%
g1 = S2.surface.X;
g2 = S2.surface.Y;
g3 = S2.surface.Z;

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);

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

X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
X2 = S2.surface.X; Y2 = S2.surface.Y; Z2 = S2.surface.Z;

%    figure(1);
trimesh(S1.surface.TRIV, X1, Y1, Z1, ...
    'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp',...
    'FaceAlpha',0.99 , 'EdgeColor', 'none');
axis equal; hold on; axis off;

%     figure(2);
trimesh(S2.surface.TRIV , X2 + xdiam, Y2 + ydiam, Z2 + zdiam, ...
    'FaceVertexCData', [g1 g2 g3], 'FaceColor','interp',...
    'FaceAlpha',0.99, 'EdgeColor', 'none');
axis equal; axis off;

if nargin > 4 % plot the landmarks
    scatter3(X1(id1),Y1(id1),Z1(id1),50,[1 0.7 0],'filled'); hold on;
    scatter3(X2(id2)+xdiam, Y2(id2)+ydiam, Z2(id2)+zdiam,50,[1 0.7 0],'filled'); hold on;
end
hold off;
end