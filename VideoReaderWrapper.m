classdef VideoReaderWrapper < handle

    properties (Access = private)
        video_reader;
    end
    
    properties (Access = public)
        
    end
    
    methods
        
        %% Constructor
        
        function obj = VideoReaderWrapper()
            
            global c;
            
            filename = ['ewap_dataset/' c.TRACKING_SEQUENCE '/' c.TRACKING_SEQUENCE '.avi'];
            
            obj.video_reader = VideoReader(filename);
            obj.video_reader .CurrentTime = c.TRACKING_START;
        end
        
        %% Misc
        
        function proceed = should_proceed(obj)
            
            global c;
            
            proceed = hasFrame(obj.video_reader) && (obj.video_reader.CurrentTime < c.TRACKING_START + c.TRACKING_DURATION);
        end
        
        function frame = read_gray_frame(obj)
            
            frame = readFrame(obj.video_reader);
            frame = rgb2gray(frame);
        end
        
        % Set time
        
        function current_time = get_current_time(obj)
            current_time = obj.video_reader.CurrentTime; 
        end
        
        function set_current_time(obj, current_time)
            obj.video_reader.CurrentTime = current_time;
        end
    end 
end
