function plot_function_scape(shape, f)
    if (nargin == 1)
        f = shape.X.*shape.Y.*shape.Z;
    end
    trimesh(shape.TRIV, shape.Y, shape.Z, shape.X, f, ...
        'EdgeColor', 'interp', 'FaceColor', 'interp');
    view([-88 28]);
    axis equal;
    axis off;
end