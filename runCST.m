function runCST(varargin)
	addpath(genpath('src/'))
	defaultControllerMode 	= 'Mouse';
	defaultDisplayMode 		= 'Graphic';
	defaultRecorder 		= 'None';
	defaultTaskRunner 		= 'Simple';
	defaultRuns				= 4;
	defaultTrialsPerRun 	= 15;

	
	p = inputParser;
	addOptional(p,'controller', defaultControllerMode, @ControllerFactory.isValidController);
	addOptional(p,'display', defaultDisplayMode, @isValidDisplay);
	addOptional(p,'runs', defaultRuns, @isValidScalarPosNum);
	addOptional(p,'trialsPerRun', defaultTrialsPerRun, @isValidScalarPosNum);
	addOptional(p,'recorder', defaultRecorder, @isValidRecorder);
	addOptional(p,'taskRunner', defaultTaskRunner, @TaskRunnerFactory.isValidTaskRunner);
	parse(p,varargin{:});
	
	task = CSTaskFactory.createCSTaskFromParameters(p.Results);
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