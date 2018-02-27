classdef TrainingController < handle & Controller
	properties
		unstableSystem,
		currentTime 		= 0,
		maxTimePerCommand 	= 2.0 % seconds
	end
	methods 
		function obj = TrainingController(unstableSystem)
			obj@Controller(-unstableSystem.boundary / 2, unstableSystem.boundary / 2)
			obj.unstableSystem = unstableSystem;
		end

		function initController(obj)

		end

		function updated = update(obj, dt)
			updated = false;
			obj.unstableSystem.state = sin(obj.currentTime) * obj.unstableSystem.boundary/2;
			obj.currentTime = obj.currentTime + dt;
		end

		function purge(obj)
			purge@Controller(obj);
			obj.currentTime = 0;
		end
	end 
end