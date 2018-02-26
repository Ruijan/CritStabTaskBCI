classdef Mouse < handle
	methods 
		function [x, y] = getMousePosition(obj)
			[x,y] = GetMouse();
		end

		function setMousePosition(obj, x, y)
			SetMouse(x, y);
		end

	end

end