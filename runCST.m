function runCST(varargin)
	addpath(genpath('src/'))
	defaultControllerMode 	= 'BCI';
	defaultDisplayMode 		= 'Graphic';
	defaultRecorder 		= 'EEG';
	defaultRuns				= 4;
	defaultTrialsPerRun 	= 15;
	
	p = inputParser;
	addOptional(p,'controller', defaultControllerMode, @ControllerFactory.isValidController);
	addOptional(p,'display', defaultDisplayMode, @isValidDisplay);
	addOptional(p,'runs', defaultRuns, @isValidScalarPosNum);
	addOptional(p,'trialsPerRun', defaultTrialsPerRun, @isValidScalarPosNum);
	addOptional(p,'recorder', defaultRecorder, @isValidRecorder);
	parse(p,varargin{:});
	if strcmp(p.Results.controller, 'Mouse') && ~strcmp(p.Results.display, 'Graphic') || ...
		strcmp(p.Results.controller, 'BCI') && ~strcmp(p.Results.display, 'Graphic')
		p.Results.display = 'Graphic';
	end
	taskRunnerMode = 'Simple';
	if strcmp(p.Results.controller, 'BCI')
		taskRunnerMode = 'BCI';
	end
	engine 				= [];
	if strcmp(p.Results.display, 'Graphic')
		engine = GraphicalEngine(2);
	end
	newSystem 			= SystemFactory.createSystem(p.Results.display, engine);
	controller 			= ControllerFactory.createController(p.Results.controller, engine, newSystem);
	taskRunner 			= TaskRunnerFactory.createTaskRunner(taskRunnerMode, p.Results.runs, p.Results.trialsPerRun);
	difficultyUpdater 	= QuestDifficultyUpdater(1.5, 5, 1.5, 0.75, 3.5, 0.99, 0.01);
	task 				= CSTaskFactory.createCSTask(...
		p.Results.display, ...
		controller, ...
		newSystem, ...
		difficultyUpdater, ...
		taskRunner, ...
		engine);
	if strcmp(p.Results.recorder, 'EEG')
		eegRecorder 		= EEGRecorder(Loop(), LoopConfiguration());
		eegRecorder.init();
		task.addRecorder(eegRecorder);
	end
	task.init();
	task.start();
	task.destroy();
end

function valid = isValidDisplay(displayMode)
	valid = true;
	if ~strcmp(displayMode,'Graphic')
		valid = false;
	end
end

function valid = isValidScalarPosNum (x)
	valid = isnumeric(x) && isscalar(x) && (x > 0);
end

function valid = isValidRecorder (recorder)
	valid = ischar(recorder);
end