function [view_vec] = set_camera_view(dataset)
switch lower(dataset)
    case 'faust'
        view_vec = [0,90];
    case 'scape'
        view_vec = [-88,28];
otherwise
view_vec = [0,0];
end
view(view_vec);
end