classdef Controller < handle
	properties
		input           = 0,
        inputMemory     = [],
        maxInput        = 0,
        minInput        = 0
	end
	methods
        function obj = Controller(minInput, maxInput)
            obj.minInput = minInput;
            obj.maxInput = maxInput;
        end
        function purge(obj)
            obj.inputMemory = [];
            obj.input       = 0;
        end
        function structure = convertToStruct(obj)
            structure = struct();
            structure.input = obj.input;
            structure.inputMemory = obj.inputMemory;
            structure.maxInput = obj.maxInput;
            structure.minInput = obj.minInput;
        end
    end
    methods(Abstract)
    	initController(obj)
    	updated = update(obj, dt)
        destroy(obj);
	end
end