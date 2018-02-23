classdef System < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        input       = 0,
        state       = 0,
        lambda      = 0,
        boundary    = 0,
        time        = 0,
        timeMemory  = [],
        stateMemory = [],
        inputMemory = [],
        expectedTimeLimit = 2
    end
    
    methods
        function obj = System()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
        end

        function init(obj, lambda, boundary, expectedTimeLimit)
            obj.lambda      = lambda;
            obj.boundary    = boundary;
            obj.expectedTimeLimit = expectedTimeLimit;
            obj.initState();
        end

        function initState(obj)
            obj.state       =  sign(rand()-0.5)*obj.boundary / exp(obj.lambda * obj.expectedTimeLimit);
        end
        
        function update(obj, dt)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.stateMemory = [obj.stateMemory; obj.state];
            obj.inputMemory = [obj.inputMemory; obj.input];
            obj.timeMemory  = [obj.timeMemory; obj.time];
            if ~obj.exploded()
                obj.time = obj.time + dt;
                obj.state = exp(obj.lambda*dt) * obj.state + (exp(obj.lambda*dt) - 1) * obj.input;
            end
        end
        
        function setInput(obj, newInput, minInput, maxInput)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.input = (newInput - (maxInput + minInput) / 2) / ((maxInput - minInput) / 2) * obj.boundary;
        end

        function reachedLimit = exploded(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            % disp([ 'State ' num2str(obj.state) ' Boundary ' num2str(obj.boundary)]);
            reachedLimit = (abs(obj.state) - obj.boundary) >= 0;
        end

        function reset(obj)
            obj.stateMemory = [];
            obj.inputMemory = [];
            obj.input       = 0;
            obj.initState();
        end
    end
end

