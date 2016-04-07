
clc;
clear all;

%------------------------------------------------
% Video and display setup

TRACKING_SEQUENCE = 'seq_hotel';
TRACKING_SEQUENCE = 'seq_eth';

TRACKING_START = 30;
TRACKING_DURATION = 3;

VIDEO_FILE                  = ['ewap_dataset/' TRACKING_SEQUENCE '/' TRACKING_SEQUENCE '.avi'];

videoReader = VideoReader(VIDEO_FILE);
videoReader.CurrentTime = TRACKING_START;

hasReadFirstFrame = false;
previousFrameGray = [];

figureHandle = figure(1);

DISPLAY_DIFFERENCE_IMAGE    = true;
DISPLAY_MARKERS             = true;

%------------------------------------------------
% Detection setup

DIFFERENCE_IMAGE_THRESHOLD  = 0.1;
COMPONENT_AREA_THRESHOLD    = 10;
CLOSE_DISC_RADIUS           = 3;

%------------------------------------------------
% ROI setup

REGION_WIDTH  = 30;
REGION_HEIGHT = 30;

regions = {};

%------------------------------------------------

while (hasFrame(videoReader) && (videoReader.CurrentTime < TRACKING_START + TRACKING_DURATION))

    % Collect data
    
    currentFrame = readFrame(videoReader);
    currentFrame = rgb2gray(currentFrame);
    
    if (~hasReadFirstFrame)
        previousFrame = currentFrame;
        hasReadFirstFrame = true;
        
        continue;
    end
    
    % Compute difference image
    
    differenceImage = imabsdiff(currentFrame, previousFrame);
    previousFrame = currentFrame;
        
    structuringElement = [1 1 1 1 1 1 1 1 1]';
    structuringElement = repmat(structuringElement, 2, 2);
    
    differenceImage = im2bw(differenceImage, DIFFERENCE_IMAGE_THRESHOLD);
    differenceImage = imclose(differenceImage, structuringElement);
    
    % Extract connected components
    
    proposed_component_centroids = regionprops(differenceImage);
    component_centroids = [];
    
    for i = 1:length(proposed_component_centroids)
       
        if (proposed_component_centroids(i).Area > COMPONENT_AREA_THRESHOLD)
            component_centroids(1:2, size(component_centroids, 2) + 1) = proposed_component_centroids(i).Centroid;
        end
    end
    
    % Region of interest calculations
    
    
    
    % Display tracking results
    
    if (~ishandle(figureHandle))
        break;
    end
    
    if (DISPLAY_DIFFERENCE_IMAGE)
        imshow(differenceImage);
    else
        imshow(currentFrame);
    end
    
    hold on;
    
    if (DISPLAY_MARKERS)
        for i = 1:size(component_centroids, 2)
            plot(component_centroids(1, i), component_centroids(2, i), 'rx');
        end
    end
   
    hold off;
    pause(0.05);
end