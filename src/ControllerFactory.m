classdef ControllerFactory < handle
	methods(Static)
		function controller = createController(varargin)
			p = inputParser;
			addRequired(p,'mode', @ControllerFactory.isValidController);
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Mouse')
				disp('Create Mouse Controller');
				controller = MouseController();
			elseif strcmp(p.Results.mode, 'BCI')
				disp('Create BCI Controller');
				Loop.addPaths();
				loop = Loop();
				tobiICGet = TobiICGet(loop);
				controller = BCIController(loop, tobiICGet);
			end

		end

		function valid = isValidController(controllerMode)
			valid = true;
			if ~ischar(controllerMode) || (~strcmp(controllerMode,'Mouse') && ...
				~strcmp(controllerMode,'LQR') && ...
				~strcmp(controllerMode,'BCI') && ...
				~strcmp(controllerMode,'Keyboard') && ...
				~strcmp(controllerMode,'None'))
				valid = false;
			end
		end
	end

end