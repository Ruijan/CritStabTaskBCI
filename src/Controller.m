classdef Controller < handle
	properties
		input       = 0,
        inputMemory = []
	end
	methods
        function obj = Controller()
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