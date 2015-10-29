function [occupied_output, empty_output]= occupied_grid(start_index, end_index, x_index_seq, y_index_seq)

    start_index_x = start_index(1);
    start_index_y = start_index(2);
    end_index_x = end_index(1);
    end_index_y = end_index(2);
    
    output = {[start_index_x, start_index_y]};
    
    x_step = sign(end_index_x - start_index_x);
    y_step = sign(end_index_y - start_index_y);
    
    if(isempty(y_index_seq)==1)
        for nu = start_index_y+y_step:y_step:end_index_y
            temp_output = [output {[start_index_x, nu]}];
            output = temp_output;
        end
    elseif(isempty(x_index_seq)==1)
        for nu = start_index_x+x_step:x_step:end_index_x
            temp_output = [output {[nu, start_index_y]}];
            output = temp_output;
        end
    else
        x_itr = 1;
        y_itr = 1;
        itr = 1;
        while (x_itr<=length(x_index_seq) || y_itr<=length(y_index_seq))
            temp = output{itr};
            if(x_itr<=length(x_index_seq) && temp(1) == x_index_seq(x_itr))
                temp_output = [output {[temp(1), temp(2)+y_step]}];
                output = temp_output;
                x_itr = x_itr + 1;
            elseif(y_itr<=length(y_index_seq) && temp(2) == y_index_seq(y_itr))
                temp_output = [output {[temp(1)+x_step, temp(2)]}];
                output = temp_output;
                y_itr = y_itr + 1;
            elseif(y_itr<=length(y_index_seq) && temp(2) == y_index_seq(y_itr)+1)
                temp_output = [output {[temp(1)+x_step, temp(2)]}];
                output = temp_output;
                y_itr = y_itr + 1;
            elseif(x_itr<=length(x_index_seq) && temp(1) == x_index_seq(x_itr)+1)
                temp_output = [output {[temp(1), temp(2)+y_step]}];
                output = temp_output;
                x_itr = x_itr + 1;
            else
                disp('Error2!');
                break;
            end
            itr = itr+1;
        end
    end
    
    if(length(output)==1)
        empty_output = output;
        occupied_output = output;
    else
        empty_output = output(1:length(output)-1);
        occupied_output = output(end);
    end
end