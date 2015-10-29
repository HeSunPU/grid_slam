function [particles, weight, map] = update_particles(particles, weight, map,...
    numReading, reading, reading_old, control, R, origin, mesh_dimen)
% update particles with new state
% written by He Sun on Oct. 26 2015
%
% particles: current particles set
% weight: current particle weight
% control: control parameter, odometry here
% R: the covariance matrix of the control input

K = length(weight);
u = mvnrnd(control, R, K);
% u_icp = icp(control', reading, reading_old);
% u_estimate = mvnrnd(u_icp, R, K);
for itr = 1 : K
    particle_temp = particles{itr};
    pose_temp = particle_temp{end};
    if length(particle_temp) == 1
        pose_temp = pose_temp{1};
    end
    
%     pose_new1 = pose_temp + u(itr,:);
%     pose_new2 = pose_temp + u_estimate(itr,:);
%     
%     weight1 = weight(itr) * ...
%         laser_point_prob(map(:,:,itr), origin, pose_new1, numReading, reading, mesh_dimen);
%     weight2 = weight(itr) * ...
%         laser_point_prob(map(:,:,itr), origin, pose_new2, numReading, reading, mesh_dimen);
%     
%     if weight1 < weight2
%         pose_new = pose_new2;
%         weight(itr) = weight2;
%     else
%         pose_new = pose_new1;
%         weight(itr) = weight1;
%     end
    
    pose_new = pose_temp + u(itr,:);
    weight(itr) = weight(itr) * ...
        laser_point_prob(map(:,:,itr), origin, pose_new, numReading, reading, mesh_dimen);
    set_temp = [particle_temp {pose_new}];
    particles{itr} = set_temp;
    map(:,:,itr) = ...
        update_map(map(:,:,itr), origin, numReading, reading, pose_new, mesh_dimen);
end
weight = normalize(weight);
end


function [weight] = normalize(weight0)
weight_sum = sum(weight0);
weight = weight0/weight_sum;
end

function u_estimate = icp(control, reading, reading_old)
    % Configurable values
    INTERP = 1; % 0 - simple ICP, 1 - ICP with interpolation
    NIT = 100;   % number of ICP iterations for each scan-match
    GATE1 = 0.5; % 1st data association gate for each point in scan
    GATE2 = 0.05;% 2nd data association gate for each point in scan
    eps = 1e-3;
    MAXR = 10 - eps;
    p1 = get_laser_points(reading_old, MAXR);
    p2 = get_laser_points(reading, MAXR);
    u_estimate = mex_icp(p1, p2, control, GATE1, NIT, INTERP);
    u_estimate = mex_icp(p1, p2, u_estimate, GATE2, NIT, INTERP);
end

function x = get_laser_points(r, MAXR)
    laser_data_num = length(r);
    step_size = pi/laser_data_num;
    phi = -pi/2+step_size:step_size:pi/2;
    ii = find(r < MAXR);
    r = r(ii); phi = phi(ii);
    x = [r.*cos(phi); r.*sin(phi)];
end
