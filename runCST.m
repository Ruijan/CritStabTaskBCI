function runCST(varargin)
	addpath('src/')
	addpath('src/interfaces')
	defaultControllerMode 	= 'Mouse';
	defaultDisplayMode 		= 'Graphic';
	defaultRuns				= 4;
	defaultTrialsPerRun 	= 15;
	
	p = inputParser;
	addOptional(p,'controller',defaultControllerMode, @ControllerFactory.isValidController);
	addOptional(p,'display',defaultDisplayMode,@isValidDisplay);
	addOptional(p,'runs',defaultRuns,@isValidScalarPosNum);
	addOptional(p,'trialsPerRun',defaultTrialsPerRun,@isValidScalarPosNum);
	parse(p,varargin{:});
	if strcmp(p.Results.controller, 'Mouse') && ~strcmp(p.Results.display, 'Graphic') || ...
		strcmp(p.Results.controller, 'BCI') && ~strcmp(p.Results.display, 'Graphic')
		p.Results.display = 'Graphic';
	end
	taskRunnerMode = 'Simple';
	if strcmp(p.Results.controller, 'BCI')
		taskRunnerMode = 'BCI';
	end

	controller 			= ControllerFactory.createController(p.Results.controller);
	newSystem 			= SystemFactory.createSystem(p.Results.display);
	task 				= CSTaskFactory.createCSTask(p.Results.display);
	taskRunner 			= TaskRunnerFactory.createTaskRunner(taskRunnerMode, p.Results.runs, p.Results.trialsPerRun);
	difficultyUpdater 	= QuestDifficultyUpdater(1.5, 5, 1.5, 0.75, 3.5, 0.99, 0.01);
	engine 				= [];
	if strcmp(p.Results.display, 'Graphic')
		engine = GraphicalEngine(2);
	end
	taskUpdateRate 			= 50; % in Hz
	task.maxTimePerTrial 	= 6;
	task.init(controller, engine, newSystem, difficultyUpdater, taskRunner, taskUpdateRate);
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