classdef GraphicalSystem < System & handle

	properties
		gBoundary 	= 0,
		gState 		= 0,
		engine
	end
	methods
		function obj = GraphicalSystem(lambda, boundary, gBoundary, nEngine)
			obj@System(lambda, boundary);
			obj.gBoundary = gBoundary;
			obj.engine = nEngine;
		end

		function update(obj, dt)
			update@System(obj, dt);
			windowSize = obj.engine.getWindowSize()
			obj.gState = [obj.state / obj.boundary * windowSize(1) windowSize(2) / 2];
			obj.engine.drawArc(obj.engine.getWhiteIndex(), obj.gState, 10, 0, 360);
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [obj.gBoundary 0], [20 600]);
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [windowSize(1) - obj.gBoundary 0], [20 600]);
		end
	end
end