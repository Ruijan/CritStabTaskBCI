classdef MouseController < handle & Controller
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
    end
    
    methods
        function obj = MouseController(engine)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@Controller(0, 1920);
            obj.engine = engine;
        end

        function initController(obj)
            windowSize = p.Results.engine.getWindowSize();
            obj.minInput = obj.engine.windowSize(3);
        end
        
        function updated = update(obj)
            % position = obj.engine.getMousePosition() - obj.engine.getCenter();
            position = obj.engine.getMousePosition();
            obj.input = position(1);
            if abs(obj.input) > obj.engine.windowSize(3)
                obj.input = sign(obj.input) * obj.engine.windowSize(3);
            end
            obj.inputMemory = [obj.inputMemory obj.input];
            updated = true;
        end

        function purge(obj)
            center = obj.engine.getCenter();
            obj.engine.setMousePosition(center(1), center(2));
        end
    end
end

