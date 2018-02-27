classdef ControllerFactory < handle
	methods(Static)
		function controller = createController(varargin)
			p = inputParser;
			addRequired(p,'mode', @ControllerFactory.isValidController);
			addOptional(p,'engine', @ControllerFactory.isValidEngine);
			addOptional(p,'system', @ControllerFactory.isValidSystem);
			parse(p,varargin{:});

			if strcmp(p.Results.mode, 'Mouse')
				disp('Create Mouse Controller');
				controller = MouseController(p.Results.engine);
			elseif strcmp(p.Results.mode, 'BCI')
				disp('Create BCI Controller');
				Loop.addPaths();
				loop = Loop();
				tobiICGet = TobiICGet(loop);
				controller = BCIController(loop, tobiICGet);
			elseif strcmp(p.Results.mode, 'Training')
				disp('Create training Controller');
				controller = TrainingController(p.Results.system);
			end
		end

		function valid = isValidController(controllerMode)
			valid = true;
			if ~ischar(controllerMode) || (~strcmp(controllerMode,'Mouse') && ...
				~strcmp(controllerMode,'LQR') && ...
				~strcmp(controllerMode,'Training') && ...
				~strcmp(controllerMode,'BCI') && ...
				~strcmp(controllerMode,'Keyboard') && ...
				~strcmp(controllerMode,'None'))
				valid = false;
			end
		end

		function valid = isValidEngine(engine)
			valid = true;
			if ~strcmp(class(engine),'GraphicalEngine')
				valid = false;
			end
		end

		function valid = isValidSystem(unstableSystem)
			valid = true;
			if ~strcmp(class(unstableSystem),'System')
				valid = false;
			end
		end
	end
end