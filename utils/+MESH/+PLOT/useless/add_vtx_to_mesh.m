function [] = add_vtx_to_mesh(S,vid,col)
scatter3(S.surface.X(vid),S.surface.Y(vid),S.surface.Z(vid),40,col,'filled'); hold on;
end