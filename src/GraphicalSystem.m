classdef GraphicalSystem < System & handle

	properties
		gBoundary 	= 0,
		gState 		= 0,
		gInput 		= 0,
		showInput 	= true,
		engine
	end
	methods
		function obj = GraphicalSystem(lambda, boundary, gBoundary, expectedTimeLimit, nEngine)
			obj@System(lambda, boundary, expectedTimeLimit);
			obj.gBoundary = gBoundary;
			obj.engine = nEngine;
		end

		function init(obj)
			init@System(obj);
		end

		function update(obj, dt)
			update@System(obj, dt);
		end
	end
end