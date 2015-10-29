function [start_index, end_index, x_index_seq, y_index_seq] = calc_path(start_point, end_point, origin, mesh_dimen)
    
    eps = 1e-3;
    
    assert(length(mesh_dimen) == 2);
    x_dimen = mesh_dimen(1);
    y_dimen = mesh_dimen(2);
    start_index = ceil((start_point-origin)./[x_dimen, y_dimen]);
    end_index = ceil((end_point-origin)./[x_dimen, y_dimen]);
    
    x_step = sign(end_index(1) - start_index(1));
    y_step = sign(end_index(2) - start_index(2));
    
    
    y_fun = @(x) start_point(2) + (x-start_point(1)) * ...
        (end_point(2)-start_point(2))/(end_point(1)-start_point(1));
    x_fun = @(y) start_point(1) + (y-start_point(2)) * ...
        (end_point(1)-start_point(1))/(end_point(2)-start_point(2));
    
    if(x_step>0)
        y_index_seq = y_fun([start_index(1):1:end_index(1)-1]*x_dimen+origin(1));
    else
        y_index_seq = y_fun([start_index(1)-1:-1:end_index(1)]*x_dimen+origin(1));
    end
    
    if(y_step>0)
        x_index_seq = x_fun([start_index(2):1:end_index(2)-1]*y_dimen+origin(2));
    else
        x_index_seq = x_fun([start_index(2)-1:-1:end_index(2)]*y_dimen+origin(2));
    end
    
    x_index_seq = ceil((x_index_seq-origin(1))/x_dimen);
    y_index_seq = ceil((y_index_seq-origin(2))/y_dimen);
    
end