classdef DiscretizedVisualFeedback < VisualFeedback & handle
	properties 
		bins 			= 8,
		frequency 		= 10, % Hz
		previousUpdate 	= 0, % s
		stateBinSize 	= 0
		showHiddenState = true
	end 

	methods 
		function obj = DiscretizedVisualFeedback(engine, system, bins, frequency)
			obj@VisualFeedback(engine, system);
			obj.bins 		= bins;
			obj.frequency 	= frequency;
		end

		function init(obj)
			init@VisualFeedback(obj);
			obj.stateBinSize = 2 * obj.system.boundary / obj.bins;
		end

		function graphicalState = getGraphicalState(obj, state)
			graphicalState = [obj.offset + floor(obj.system.state / obj.stateBinSize) * ...
				obj.stateBinSize  + obj.stateBinSize / 2 + obj.boundary...
				obj.windowSize(4) / 2];
			if graphicalState(1) <= obj.offset
				graphicalState = [obj.offset + obj.stateBinSize / 2 + obj.boundary...
					obj.windowSize(4) / 2];
			elseif graphicalState(1) >= 2 * obj.boundary + obj.offset
				graphicalState = [obj.offset + obj.bins * obj.stateBinSize + obj.stateBinSize / 2 + obj.boundary...
					obj.windowSize(4) / 2];
			end
			% graphicalState = [offset + obj.system.state / obj.boundary * obj.boundary + obj.boundary windowSize(4) / 2];
		end

		function drawGraphicalState(obj, graphicalState)
			obj.engine.drawFilledRect([0 255 0], graphicalState, [obj.stateBinSize obj.windowSize(4) / 3]);
		end

		function destroy(obj)
			obj.engine.showCursor();
		end

		function endTrial(obj)

		end
	end 
end 