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
            windowSize = obj.engine.getWindowSize();
            obj.minInput = 0;
            obj.maxInput = windowSize(3);
        end
        
        function updated = update(obj, dt)
            % position = obj.engine.getMousePosition() - obj.engine.getCenter();
            position = obj.engine.getMousePosition();
            obj.input = position(1);
            if obj.input > obj.maxInput
                obj.input = sign(obj.input) * obj.maxInput;
            elseif obj.input < obj.minInput
                obj.input = sign(obj.input) * obj.minInput;
            end
            obj.inputMemory = [obj.inputMemory obj.input];
            updated = true;
        end

        function purge(obj)
            center = obj.engine.getCenter();
            obj.engine.setMousePosition(center(1), center(2));
        end

        function destroy(obj)

        end
    end
end

