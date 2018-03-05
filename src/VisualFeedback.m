classdef VisualFeedback < Feedback & handle
	properties 
		engine,
		boundary,
		showInput = false
	end 

	methods 
		function obj = VisualFeedback(engine, system)
			obj@Feedback(system);
			obj.engine = engine;
		end

		function init(obj)
			windowSize = obj.engine.getWindowSize();
			obj.boundary = windowSize(3) * 0.4;
		end

		function update(obj)
			windowSize = obj.engine.getWindowSize();
			offset = windowSize(3)*0.1;

			gState = [offset + obj.system.state / obj.boundary * obj.boundary + obj.boundary windowSize(4) / 2];
			obj.engine.drawFilledCircle(obj.engine.getWhiteIndex(), gState, 10);
			if obj.showInput
				gInput = [offset + obj.system.input / obj.boundary * obj.boundary + obj.boundary windowSize(4) / 3];
				obj.engine.drawFilledCircle([0 0 255], gInput, 10);
			end
			obj.drawBoundaries(windowSize, offset)

			if obj.engine.checkIfKeyPressed('S')
                obj.showInput = ~obj.showInput;
            end
		end

		function drawBoundaries(obj, windowSize, offset)
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), ...
				[obj.boundary * 2 + offset windowSize(4) / 2], [10 windowSize(4) / 3]);
			obj.engine.drawFilledRect(obj.engine.getWhiteIndex(), ...
				[offset windowSize(4)/2], [10 windowSize(4) / 3]);
		end 
	end 
end 