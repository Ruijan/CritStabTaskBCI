classdef Feedback < handle & matlab.mixin.Heterogeneous
	properties
		system
	end 
	methods 
		function obj = Feedback(system)
			obj.system = system;
		end
	end 
	methods(Abstract)
		init(obj)
		update(obj)
		destroy(obj)
		endTrial(obj)
	end 
end