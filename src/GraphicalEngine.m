classdef GraphicalEngine < handle

	properties
		window 		= 0,
		windowSize 	= 0,
		setup 		= 2
		previousKeyPressed = 0;
	end
	methods
		function obj = GraphicalEngine(setup)
			PsychDefaultSetup(setup);
			Screen('Preference', 'SkipSyncTests', 2);
            KbName('UnifyKeyNames');
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
			Screen('FillRect',obj.window, uint8(objColor),[position - rectSize ./ 2, position + ...
                        rectSize ./ 2]);
		end

		function drawText(obj, textToDisplay, postion, objColor)
			DrawFormattedText(obj.window,textToDisplay,'center','center', objColor);
			% Screen('DrawText', obj.window, textToDisplay, postion(1), postion(2), objColor);
		end
		function whiteIndex = getWhiteIndex(obj)
			whiteIndex = WhiteIndex(obj.window);
		end
		function wSize = getWindowSize(obj)
			wSize = obj.windowSize;
		end

		function closeAllWindows(obj)
			Screen('CloseAll');
		end

		function updateScreen(obj)
			Screen('Flip', obj.window);
		end

		function [x, y] = getMousePosition(obj)
			[x,y] = GetMouse();
		end

		function setMousePosition(obj, x, y)
			SetMouse(x, y);
		end

		function center = getCenter(obj)
			center = obj.windowSize(3:4) ./ 2;
		end

		function keyPressed = checkIfKeyPressed(obj, key)
			keyboardKey = KbName(key);
			[a,b,keyCode] = KbCheck;
			keyPressed = false;
			if any(keyCode(keyboardKey))
				if obj.previousKeyPressed ~= keyboardKey
					keyPressed = true;
					obj.previousKeyPressed = keyboardKey;
				end
			else
				obj.previousKeyPressed = 0;
			end
		end
	end
end