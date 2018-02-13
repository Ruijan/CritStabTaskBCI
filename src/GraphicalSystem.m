classdef GraphicalSystem < System & handle

	properties
		gBoundary 	= 0,
		gState 		= 0
	end
	methods
		function obj = GraphicalSystem(lambda, boundary, gBoundary)
			obj@System(lambda, boundary);
			obj.gBoundary = gBoundary;
		end
		function init(obj)
			PsychDefaultSetup(2);
			screens = Screen('Screens');
			screenNumber = max(screens);
			white = WhiteIndex(screenNumber);
			black = BlackIndex(screenNumber);
			grey = white / 2;
			[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

		end
	end
end