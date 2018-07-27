function [cov] = visualize_map_colors_with_coverage(S1,S2,map,para_in, id1, id2)
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

n2 = size(X2,1);

f = zeros(n2,1);
f(unique(map)) = 1;
cov = 100*length(unique(map))/n2; % coverage rate
alpha1 = 0.99;
alpha2 = 0.99;
if nargin > 4
    alpha2 = 0.8;
end



%    figure(1);
trimesh(S1.surface.TRIV, X1, Y1, Z1, ...
    'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp',...
    'FaceAlpha',alpha1, 'EdgeColor', 'none');
axis equal; hold on; axis off;

%     figure(2);
trimesh(S2.surface.TRIV , X2 + xdiam, Y2 + ydiam, Z2 + zdiam, ...
    'FaceVertexCData', [f.*g1, f.*g2 ,f.*g3], 'FaceColor','interp',...
    'FaceAlpha',alpha2, 'EdgeColor', 'none');
axis equal; hold on; axis off;
title(['coverage rate: ',num2str(cov,'%2.2f'),'%'])

if nargin > 4 % plot the landmarks
    scatter3(X1(id1),Y1(id1),Z1(id1),50,[1,0.7,0],'filled'); hold on;
    scatter3(X2(map(id1))+xdiam, Y2(map(id1))+ydiam, Z2(map(id1))+zdiam,50,[1,0.24,0.24],'filled'); hold on;
    scatter3(X2(id2)+xdiam, Y2(id2)+ydiam, Z2(id2)+zdiam,50,[1,0.7,0],'filled'); hold on;
    
    Xstart = X2(map(id1))'; Xend = X2(id2)';
    Ystart = Y2(map(id1))'; Yend = Y2(id2)';
    Zstart = Z2(map(id1))'; Zend = Z2(id2)';
    
    
    Xstart = Xstart + xdiam;
    Ystart = Ystart + ydiam;
    Zstart = Zstart + zdiam;
    Xend = Xend + xdiam;
    Yend = Yend + ydiam;
    Zend = Zend + zdiam;
    
    
    Colors = [1,0.24,0.24];
    ColorSet = repmat(Colors,length(id1),1);
    set(gca, 'ColorOrder', ColorSet);
    plot3([Xstart; Xend], [Ystart; Yend], [Zstart; Zend],'LineWidth',2,'LineStyle','-'); hold off;
end

hold off;
end