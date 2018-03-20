classdef VisualFeedback < Feedback & handle
	properties 
		engine,
		boundary,
		showInput = true,
		showInputKey = NaN;
		windowSize = [];
		offset = [];
	end 

	methods 
		function obj = VisualFeedback(engine, system)
			obj@Feedback(system);
			obj.engine = engine;
		end

		function init(obj)
			windowSize = obj.engine.getWindowSize();
			obj.boundary = windowSize(3) * 0.4;
			obj.engine.hideCursor();
			obj.showInputKey = obj.engine.getKeyboardKey('S');
			obj.engine.addEnabledKeyInput(obj.showInputKey);
			obj.windowSize = obj.engine.getWindowSize();
			obj.offset = windowSize(3)*0.1;
		end

		function update(obj, dt)
			obj.drawSystem();
			obj.drawBoundaries();

			if obj.engine.checkIfKeyPressed(obj.showInputKey)
                obj.showInput = ~obj.showInput;
            end
		end

		function drawSystem(obj)
			graphicalState = obj.getGraphicalState(obj.system.state);
			obj.drawGraphicalState(graphicalState)
			if obj.showInput
				graphicalInput = obj.getGraphicalInput(obj.system.input);
				obj.drawGraphicalInput(graphicalInput);
			end
		end

		function drawBoundaries(obj)
		    obj.engine.drawText('+', obj.engine.getCenter() + [-150, -100], [255 255 255]);
			obj.engine.drawFilledRect([255 0 0], ...
				[obj.boundary * 2 + obj.offset obj.windowSize(4) / 2], [10 obj.windowSize(4) / 3]);
			obj.engine.drawFilledRect([255 0 0], ...
				[obj.offset obj.windowSize(4)/2], [10 obj.windowSize(4) / 3]);
		end 

		function graphicalState = getGraphicalState(obj, state)
			graphicalState = [obj.offset + state / obj.boundary * obj.boundary + obj.boundary obj.windowSize(4) / 2];
		end

		function graphicalInput = getGraphicalInput(obj, systemInput)
			graphicalInput = [obj.offset + systemInput / obj.boundary * obj.boundary + obj.boundary obj.windowSize(4) / 3];
		end

		function drawGraphicalState(obj, graphicalState)
			obj.engine.drawFilledCircle([255 255 255], graphicalState, 20);
		end

		function drawGraphicalInput(obj, graphicalInput)
			obj.engine.drawFilledCircle([0 0 255], graphicalInput, 20);
		end

		function endTrial(obj)

		end

		function destroy(obj)
			obj.engine.showCursor();
		end
	end 
end 