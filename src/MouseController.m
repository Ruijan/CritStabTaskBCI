classdef MouseController < handle & Controller
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
    end
    
    methods
        function obj = MouseController()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@Controller();
        end

        function initController(obj, engine)
            obj.engine = engine;
        end
        
        function updated = update(obj)
            position = obj.engine.getMousePosition() - obj.engine.getCenter();
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

