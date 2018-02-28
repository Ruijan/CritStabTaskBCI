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
			windowSize = obj.engine.getWindowSize();
			offset = windowSize(3)*0.1;
			obj.gState = [offset + obj.state / obj.boundary * obj.gBoundary + obj.gBoundary windowSize(4) / 2];
			obj.engine.drawArc(obj.engine.getWhiteIndex(), obj.gState, 10, 0, 360);
			if obj.showInput
				obj.gInput = [offset + obj.input / obj.boundary * obj.gBoundary + obj.gBoundary windowSize(4) / 3];
				obj.engine.drawArc(obj.engine.getWhiteIndex(), obj.gInput, 10, 0, 360);
			end

			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [obj.gBoundary * 2 + offset windowSize(4)/2], [10 600]);
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), [offset windowSize(4)/2], [10 600]);
		end
	end
end