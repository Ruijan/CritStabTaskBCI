classdef GraphicalEngine < handle

	properties
		window 		= 0,
		windowSize 	= 0,
		setup 		= 2
	end
	methods
		function obj = GraphicalEngine(setup)
			PsychDefaultSetup(setup);
			obj.setup = setup;
		end

		function openWindow(obj, windowSize)
			[obj.window, obj.windowSize] = PsychImaging('OpenWindow', 0, 0, windowSize);
		end

		function drawArc(obj, objColor, position, radius, fromAngle, toAngle)
			Screen('DrawArc',obj.window, uint8(objColor),[position - radius, position + ...
                        radius],fromAngle, toAngle);
		end
		function drawFilledRect(obj, objColor, position, rectSize)
			Screen('DrawArc',obj.window, uint8(objColor),[position - rectSize ./ 2, position + ...
                        rectSize ./ 2],fromAngle, toAngle);
		end
		function whiteIndex = getWhiteIndex(obj)
			whiteIndex = WhiteIndex(obj.window);
		end
		function wSize = getWindowSize(obj)
			wSize = obj.windowSize;
		end
	end
end