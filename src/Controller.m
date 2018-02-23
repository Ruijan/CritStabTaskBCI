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
        end
    end
    methods(Abstract)
    	initController(obj)
    	updated = update(obj)
	end
end