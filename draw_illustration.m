function draw_illustration(particles, weight, map)
K = length(weight);
[val, index] = max(weight);
figure(1), imagesc(map(:,:,index)); axis xy equal tight; colorbar
xlim([120,280]); ylim([80, 240]);
drawnow
% hold on
points_cloud = zeros(K, 3);
for itr = 1 : K
    particle_temp = particles{itr};
    pose_temp = particle_temp{end};
    if length(particle_temp) == 1
        points_cloud(itr,:) = pose_temp{1};
    else points_cloud(itr,:) = pose_temp;
    end
end
figure(2), plot(points_cloud(:,1), points_cloud(:,2), 'r.');
xlim([-40,40]); ylim([-40,40])
drawnow

% hold on
end