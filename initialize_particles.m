function [particles, weight, map] = ...
    initialize_particles(x0, R, K, origin, numReading, reading, range, mesh_dimen)
% generate initial particles
% written by He Sun on Oct. 26, 2015
%
% x0: the initial position of the robot
% R: the covariance matrix of the initial position
% K: number of partiles in the set

x = mvnrnd(x0, R, K);
particles = cell(1, K);
map = 0.5*ones(ceil(range(1)/mesh_dimen(1)), ceil(range(2)/mesh_dimen(2)), K);
for itr = 1 : K
    particles{itr} = {{x(itr,:)}};
    map(:,:,itr) = ...
        update_map(map(:,:,itr), origin, numReading, reading, x(itr,:), mesh_dimen);
end

weight = 1/K * ones(K,1);
 
end