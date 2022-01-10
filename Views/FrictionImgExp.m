% load experiment
load experiment1;
proccessed = experiment1;
fpms = 50;
totalTime = size(experiment1, 3)/fpms;
msPerFrame = 1/fpms;
micronsPerXPixel = 50;
micronsPerYPixel = 13.5;
Smoothing
smoothing = false;
if(smoothing)
    timeSmoothing = 7;
    threshold = 0.97;
    xSmoothing = 23;
    zSmoothing  = 27;
    proccessed = SmoothExperiment(experiment1, timeSmoothing, threshold, xSmoothing, zSmoothing);
else
    processed = experiment1;
end

Plot Experiment
t=0.88;
current = proccessed(:,:,round(t*fpms)+1);
imagesc(current);
caxis([0.9 1.01]);
if(~smoothing)
    colorbar;
end
title("Experiment");
xticks([]);
yticks([]);
xlabel(micronsPerXPixel * size(experiment1,1) + " (micron)");
ylabel(micronsPerYPixel * size(experiment1,2) + " (micron)");

% plot front
if(smoothing)
    boundaries = bwboundaries(~current);
    hold on;
for k = 1:length(boundaries)
   boundary = boundaries{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
hold off;
end


Velocity
% get parameters
if(smoothing)
thresholds = [0.97;0.98;0.985];
velocities = [{} {} {}];
areas = [{} {} {}];
perimeters = [{} {} {}];
betas = [{} {} {}];

for i=1:length(thresholds)
    current = SmoothExperiment(experiment1,timeSmoothing,thresholds(i), xSmoothing, zSmoothing);
    scaled = ScaleImage(current,micronsPerXPixel/micronsPerYPixel);
    [Area,Perimeter,Velocity,Beta] = GetParameters(scaled);
    velocities(i) = {Velocity * micronsPerXPixel} ;
    areas(i) = {Area * micronsPerXPixel * micronsPerXPixel} ;
    perimeters(i) = {Perimeter} ;
    betas(i) = {Beta};
end

timeLine = (1:size(experiment1,3)) / fpms;

for i=1:length(thresholds)
    plot(timeLine,velocities{i});
    hold on;
end
hold off;
title("Velocity");
xlabel("time (ms)");
ylabel("velocity (micron / ms)");
xlim([1 3]);
ylim([0 750]);

end
Area
for i=1:length(thresholds)
    plot(timeLine,areas{i});
    hold on;
end
hold off;
title("Area");
xlabel("time (ms)");
ylabel("area (micron^2");
Perimeter
for i=1:length(thresholds)
    plot(timeLine,perimeters{i});
    hold on;
end
hold off;
title("Perimeter length");
xlabel("time (ms)");
ylabel("perimeter (micron)");
Beta
for i=1:length(thresholds)
    plot(timeLine,betas{i});
    hold on;
end
hold off;
title("Beta");
xlabel("time (ms)");
ylabel("beta");

