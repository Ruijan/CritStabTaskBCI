classdef GraphicalSystem < System & handle

	properties
		gBoundary 	= 0,
		gState 		= 0,
		gInput 		= 0,
		engine
	end
	methods
		function obj = GraphicalSystem()
			obj@System();
		end

		function init(obj, lambda, boundary, gBoundary, expectedTimeLimit, nEngine)
			init@System(obj, lambda, boundary, expectedTimeLimit);
			obj.gBoundary = gBoundary;
			obj.engine = nEngine;
		end

		function update(obj, dt)
			disp('Update Graphical system');
			update@System(obj, dt);
			windowSize = obj.engine.getWindowSize();
			offset = windowSize(3)*0.1;
			obj.gState = [offset + obj.state / obj.boundary * obj.gBoundary + obj.gBoundary windowSize(4) / 2];
			% obj.gInput = [offset + obj.input / obj.boundary * obj.gBoundary + obj.gBoundary windowSize(4) / 3];
			obj.engine.drawArc(obj.engine.getWhiteIndex(), obj.gState, 10, 0, 360);
			% obj.engine.drawArc(obj.engine.getWhiteIndex(), obj.gInput, 10, 0, 360);

			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [obj.gBoundary * 2 + offset windowSize(4)/2], [10 600]);
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [offset windowSize(4)/2], [10 600]);
		end
	end
end