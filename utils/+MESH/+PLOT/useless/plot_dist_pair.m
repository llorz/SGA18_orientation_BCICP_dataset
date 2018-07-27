function [] = plot_dist_pair(S)
pairs = S.pairs;
D = [S.surface.X, S.surface.Y, S.surface.Z];

trimesh(S.surface.TRIV, S.surface.X, S.surface.Y, S.surface.Z, ...
'FaceVertexCData',[192,192,192]/256,'FaceColor','flat', 'EdgeColor', 'none'); axis equal;
hold on;
for i = 1:size(pairs,1)
plot3(D(pairs(i,:),1),D(pairs(i,:),2),D(pairs(i,:),3),'--',...
    'color',[128,128,128]/256,'linewidth',0.5); 
% plot3(D(pairs(i,:),1),D(pairs(i,:),2),D(pairs(i,:),3),'--',...
%     'color',S.pairs_col(i,:),'linewidth',0.5);
hold on;
end
axis off;
hold off;
end