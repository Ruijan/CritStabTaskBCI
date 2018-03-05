classdef Feedback < handle
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
	end 
end