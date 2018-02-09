classdef System < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        input       = 0,
        state       = 0,
        lambda      = 0,
        boundary    = 0,
        stateMemory = [],
        inputMemory = []
    end
    
    methods
        function obj = System(lambda, boundary)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.lambda      = lambda;
            obj.boundary    = boundary;
        end
        
        function update(obj, dt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.stateMemory = [obj.stateMemory; obj.state];
            obj.inputMemory = [obj.inputMemory; obj.input];
            if ~obj.exploded()
                obj.state = exp(obj.lambda*dt) * obj.state + (exp(obj.lambda*dt) - 1) * obj.input;
            end
        end
        
        function setInput(obj, newInput)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.input = newInput;
        end
        function reachedLimit = exploded(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            reachedLimit = (abs(obj.state) - obj.boundary) >= 0;
        end
    end
end

