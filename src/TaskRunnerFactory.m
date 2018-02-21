classdef TaskRunnerFactory < handle

	methods(Static)
		function taskRunner = createTaskRunner(runnerMode, runs, trialsPerRun)
			if ~TaskRunnerFactory.isValidTaskRunner(runnerMode)
				error('Invalid task runner mode. Expected Simple or BCI');
			end
			if strcmp(runnerMode,'Simple')
				taskRunner = TaskRunner(runs, trialsPerRun);
			elseif strcmp(runnerMode,'BCI')
				Loop.addPaths();
				loop = Loop();
				tobiIDSet = TobiIDSet(loop);
				taskRunner = ConnectedTaskRunner(loop, tobiIDSet, runs, trialsPerRun);
			end
				
		end

		function valid = isValidTaskRunner(runnerModer)
			valid = true;
			if ~ischar(runnerModer) || (~strcmp(runnerModer,'Simple') && ...
				~strcmp(runnerModer,'BCI'))
				valid = false;
			end
		end
	end
end