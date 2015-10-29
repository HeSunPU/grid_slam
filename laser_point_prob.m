function output = laser_point_prob(map, origin, pose, numReading, reading, mesh_dimen)
% given the start pose and data from laser range data, calculate the
% terminating points, and then calculation the probability that all the
% terminating points are occupied.
%
% written by He Sun on Oct. 26, 2015

MAXR = 8;

x_start = pose(1);
y_start = pose(2);
angle = pose(3);
angle_deg = rad2deg(angle);

step_size = 3;
output = 1;
amp_factor = 1.3;

for itr = 1 : step_size : numReading
    dist = reading(itr);
    if dist < MAXR
        degree = angle_deg + 90 - itr;
        x_end = x_start + dist*cosd(degree);
        y_end = y_start + dist*sind(degree);

        [x_index_end, y_index_end] = coord2index(x_end, y_end, origin, mesh_dimen);
        if(x_index_end < size(map,2) && y_index_end < size(map,1))
            output = output * amp_factor * map(y_index_end, x_index_end);
        end
        if output < 1e-10
            output = 5e-11;
        elseif output >1e10
            output = 5e10;
        end
    end
end

end

function [x_index, y_index] = coord2index(x, y, origin, mesh_dimen)
    x_index = ceil((x-origin(1))/mesh_dimen(1));
    y_index = ceil((y-origin(2))/mesh_dimen(2));
end