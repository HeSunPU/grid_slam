function demo_rbkfslam()
%% demo to run rao-blackwellized particle filter
% written by He Sun on Oct. 26, 2015

%% load data.mat
% this is a test dataset from OpenSLAM collected from ACES3 building, UT
% Austin
load data.mat

%% set parameters

%set the intitial state, motion model covariance matrix and number of particles
x0 = pose(1,:);
R = [0.1^2,0,0;0,0.1^2,0;0,0,1^2];
K = 300;
max_step = length(numReadings);
% set parameters of the map
range = [160, 160];
mesh_dimen = [0.5, 0.5];
origin = [-100, -80];

%% Rao-Blackwellized particle filter, let's go
xwidth = 1000;
ywidth = 1500;

hFig1 = figure(1);
set(hFig1, 'Position', [0 0 xwidth ywidth])
filename1 = 'grid_map3.gif';

hFig2 = figure(2);
set(hFig2, 'Position', [0 0 xwidth ywidth])
filename2 = 'particles3.gif';



disp('Start Grid-based Rao-Blackwellized particle filter SLAM');
numReading = numReadings(400);
reading = readings(400,:);
[particles, weight, map] = ...
    initialize_particles(x0, R, K, origin, numReading, reading, range, mesh_dimen);
draw_illustration(particles, weight, map);

%%
flag = 0;
gap = 10;
fac = 5;
reading_old = reading;
max_step = 1300;
for step =  500+gap: gap :max_step
    disp(['moving to step' num2str(step)]);
    disp(['the max weight now is' num2str(max(weight))]);
    numReading = numReadings(step);
    reading = readings(step,:);
    motion = sum(control(step-gap+1:step,:));
    %motion = control(step,:);
    R = [(min(0.1,motion(1)/fac))^2,0,0;0,(min(1, motion(2)/fac))^2,0;0,0,(min(0.1, motion(3)/fac))^2];
    [particles, weight, map] = update_particles(particles, weight, map,...
    numReading, reading, reading_old, motion, R, origin, mesh_dimen);
    disp(['moving to step' num2str(step)]);
    disp(['the max weight before update is' num2str(max(weight))]);
    draw_illustration(particles, weight, map);
    [particles, weight, map] = resampling(particles, weight, map);
    reading_old = reading;
    
    frame1 = getframe(1);
    im1 = frame2im(frame1);
    [imind1, cm1] = rgb2ind(im1, 256);
    

    frame2 = getframe(2);
    im2 = frame2im(frame2);
    [imind2, cm2] = rgb2ind(im2, 256);
    
    if flag ==0
        imwrite(imind1, cm1, filename1, 'gif', 'Loopcount', inf);
        imwrite(imind2, cm2, filename2, 'gif', 'Loopcount', inf);
        flag = 1;
    else
   
        imwrite(imind1, cm1, filename1, 'gif', 'WriteMode', 'append');
        imwrite(imind2, cm2, filename2, 'gif', 'WriteMode', 'append');
    end
   
    
    

end


%% generate grid map directly from odometry
gap = 2;
map = 0.5*ones(ceil(range(1)/mesh_dimen(1)), ceil(range(2)/mesh_dimen(2)));
for step = gap+1 : gap :max_step
    disp(['moving to step' num2str(step)]);
    numReading = numReadings(step);
    reading = readings(step,:);
    map = update_map(map, origin, numReading, reading, pose(step,:), mesh_dimen);
    figure(3), imagesc(map); axis xy equal tight; colorbar; drawnow
    %xlim([120,280]); ylim([80, 240]);
end




