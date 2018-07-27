function [] = plot_edges_on_mesh(S,e_id)

n = size(S.A,1);

if isfield(S,'Elist')
    Elist = S.Elist;
else
    Elist = get_mesh_edge_list(S);
end

v_id = reshape(Elist(e_id,:),[],1);

% v_id = reshape(Elist(e_id,1),[],1);
v_color = zeros(n,1);
v_color(v_id) = 0.5;

trimesh(S.surface.TRIV, S.surface.X, S.surface.Y, S.surface.Z,v_color, ...
    'FaceColor','interp', 'EdgeColor', 'none','FaceAlpha',0.8); axis equal; axis off;
title('region boundary')

end