function [particles_new, weight_new, map_new] = resampling(particles, weight, map)
% calculate the resampling coefficient n_eff, if n_eff is smaller than
% certen number epslion, do resampling; otherwise, leave the particle set
% as it is.
%
% written by He Sun on Oct. 26, 2015

K = length(weight);
eps = sqrt(K)/2;
n_eff = 1/(sum(weight.^2));

if n_eff < eps
    [particles_new, weight_new, map_new] = low_variance_resampling(particles, weight, map, K);
elseif n_eff >= eps
    particles_new = particles;
    weight_new = weight;
    map_new = map;
else
    particles_new = particles;
    map_new = map;
    weight_new = 1/K * ones(size(weight));
end

end

function [particles_new, weight_new, map_new] = low_variance_resampling(particles, weight, map, K)
% use a Roulette wheel to do stochastic universal resampling

particles_new = cell(1, K);
map_new = zeros(size(map));
r = unifrnd(0, 1/K);
c = weight(1);
i = 1;
for j = 1 : K
    U = r + (j-1)/K;
    while U > c
        i = i + 1;
        c = c + weight(i);
    end
    particles_new{j} = particles{i};
    map_new(:,:,j) = map(:,:,i);
end
weight_new = 1/K * ones(size(weight));
end