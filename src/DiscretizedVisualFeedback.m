classdef DiscretizedVisualFeedback < VisualFeedback & handle
	properties 
		bins 			= 8,
		frequency 		= 2, % Hz
		previousUpdate 	= 0, % s
		stateBinSize 	= 0
		showHiddenState = true
		graphicalState
	end 

	methods 
		function obj = DiscretizedVisualFeedback(engine, nSystem, bins, frequency)
			obj@VisualFeedback(engine, nSystem);
			obj.bins 		= bins;
			obj.frequency 	= frequency;
		end

		function init(obj)
			init@VisualFeedback(obj);
			obj.stateBinSize = 2 * obj.system.boundary / obj.bins;
			obj.updateGraphicalState();
		end

		function update(obj, dt)
			obj.previousUpdate = obj.previousUpdate + dt;
			if obj.previousUpdate > 1 / obj.frequency
				obj.previousUpdate = 0;
				obj.updateGraphicalState();
			end
			update@VisualFeedback(obj,dt);
		end

		function updateGraphicalState(obj)
			obj.graphicalState = [obj.offset + floor(obj.system.state / obj.stateBinSize) * ...
				obj.stateBinSize  + obj.stateBinSize / 2 + obj.boundary...
				obj.windowSize(4) / 2];
			if obj.graphicalState(1) <= obj.offset
				obj.graphicalState = [obj.offset + obj.stateBinSize / 2 + obj.boundary...
					obj.windowSize(4) / 2];
			elseif obj.graphicalState(1) >= 2 * obj.boundary + obj.offset
				obj.graphicalState = [obj.offset + obj.bins * obj.stateBinSize + obj.stateBinSize / 2 + obj.boundary...
					obj.windowSize(4) / 2];
			end
		end

		function graphicalState = getGraphicalState(obj, state)
			graphicalState = obj.graphicalState;
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