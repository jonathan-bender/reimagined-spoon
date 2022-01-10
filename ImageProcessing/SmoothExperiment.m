function Processed=SmoothExperiment(mat, timeSmoothing, threshold, xSmoothing, zSmoothing)

%-- smooth over space time for errors
smoothed = smooth3(mat, 'box', [3 3 timeSmoothing]);

%-- threshold
thresholdMat = smoothed > threshold;

%-- filter to get a clear boundry of the blob
Processed = medfilt3(thresholdMat, [xSmoothing zSmoothing 1]);

end
