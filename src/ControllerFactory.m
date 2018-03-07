classdef ControllerFactory < handle
	methods(Static)
		function controller = createController(varargin)
			p = inputParser;
			addRequired(p,'mode', @ControllerFactory.isValidController);
			addRequired(p,'engine', @ControllerFactory.isValidEngine);
			addRequired(p,'system', @ControllerFactory.isValidSystem);
			addRequired(p,'loop', @ControllerFactory.isValidLoop);
			addRequired(p,'tobiICGet', @ControllerFactory.isValidTobiICGet);
			parse(p,varargin{:});

			if strcmp(p.Results.mode, 'Mouse')
				disp('Create Mouse Controller');
				controller = MouseController(p.Results.engine);
			elseif strcmp(p.Results.mode, 'BCI')
				disp('Create BCI Controller');
				controller = BCIController(p.Results.loop, p.Results.tobiICGet);
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
			if ~strcmp(class(unstableSystem),'System') && ~strcmp(class(unstableSystem),'GraphicalSystem')
				valid = false;
			end
		end

		function valid = isValidLoop(loop)
			valid = true;
			if ~strcmp(class(loop),'Loop') && ~isempty(loop)
				valid = false;
			end
		end

		function valid = isValidTobiICGet(tobiICGet)
			valid = true;
			if ~strcmp(class(tobiICGet),'TobiICGet') && ~isempty(tobiICGet)
				valid = false;
			end
		end
	end
end