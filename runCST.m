function runCST(varargin)
	addpath('src/')
	addpath('src/interfaces')
	defaultControllerMode 	= 'Mouse';
	defaultDisplayMode 		= 'Graphic';
	defaultRuns				= 4;
	defaultTrialsPerRun 	= 15;
	
	p = inputParser;
	addOptional(p,'controller',defaultControllerMode, @ControllerFactory.isValidController);
	addOptional(p,'display',defaultDisplayMode,@validScalarPosNum);
	addOptional(p,'runs',defaultRuns,@isValidScalarPosNum);
	addOptional(p,'trialsPerRun',defaultTrialsPerRun,@isValidScalarPosNum);
	parse(p,varargin{:});
	if strcmp(p.Results.controller, 'Mouse') && ~strcmp(p.Results.display, 'Graphic') || ...
		strcmp(p.Results.controller, 'BCI') && ~strcmp(p.Results.display, 'Graphic')
		p.Results.display = 'Graphic';
	end

	varargs = {}
	engine = [];
	task = [];
	controller = ControllerFactory.createController(p.Results.controller);
	newSystem = SystemFactory.createSystem(p.Results.display);
	task = CSTaskFactory.createCSTask(p.Results.display);
	if strcmp(p.Results.display, 'Graphic')
		engine = GraphicalEngine(2);
	end
	task.init(controller, engine, newSystem, p.Results.runs, p.Results.trialsPerRun, 50);
	
	task.start();
	task.destroy();
end

function valid = isValidDisplay(displayMode)
	valid = true;
	if displayMode ~= 'Graphic' && ...
		controllerMode ~= 'None'
		valid = false;
	end
end
function valid = isValidScalarPosNum (x)
	valid = isnumeric(x) && isscalar(x) && (x > 0);
end