function output = update_map(prob_map, origin, numReading, reading, pos, mesh_dimen)
    
    MAXR = 8;
    x_pose = pos(1);
    y_pose = pos(2);
    angle_pose = pos(3);
    angle_pose_deg = rad2deg(angle_pose);
    output = prob_map;
    start_point = [x_pose, y_pose];
    
    prob_empty = 0.4;
    prob_occupied = 0.75;
    factor_empty = (1-prob_empty)/prob_empty;
    factor_occupied = (1-prob_occupied)/prob_occupied;
    
    for nu_readings = 1:numReading
        
        dist = reading(nu_readings);
        if dist < MAXR
            degree = angle_pose_deg + 90 - nu_readings;
            x_point = x_pose + dist*cosd(degree);
            y_point = y_pose + dist*sind(degree);
            end_point = [x_point, y_point];

            [start_index, end_index, x_index_seq, y_index_seq] = calc_path(start_point, end_point, origin, mesh_dimen);
            [occupied_output, empty_output]= occupied_grid(start_index, end_index, x_index_seq, y_index_seq);

            for itr = 1:length(empty_output)
                temp_coord = empty_output{itr};
                x_coord = temp_coord(1);
                y_coord = temp_coord(2);
                output(y_coord, x_coord) = ...
                    1 / (1 + factor_empty*((1-output(y_coord, x_coord))/output(y_coord, x_coord)));
            end
            temp_coord = occupied_output{1};
            x_coord = temp_coord(1);
            y_coord = temp_coord(2);
            output(y_coord, x_coord) = ...
                    1 / (1 + factor_occupied*((1-output(y_coord, x_coord))/output(y_coord, x_coord)));
        end
        
    end
    
end