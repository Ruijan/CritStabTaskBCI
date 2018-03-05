classdef TaskRunnerFactory < handle

	methods(Static)
		function taskRunner = createTaskRunner(runnerMode, runs, trialsPerRun, loop, tobiIDSet)
			if ~TaskRunnerFactory.isValidTaskRunner(runnerMode)
				error('Invalid task runner mode. Expected Simple or Connected');
			end
			if strcmp(runnerMode,'Simple')
				taskRunner = TaskRunner(runs, trialsPerRun);
			elseif strcmp(runnerMode,'Connected')
				taskRunner = ConnectedTaskRunner(loop, tobiIDSet, runs, trialsPerRun);
			end
				
		end

		function valid = isValidTaskRunner(runnerModer)
			valid = true;
			if ~ischar(runnerModer) || (~strcmp(runnerModer,'Simple') && ...
				~strcmp(runnerModer,'Connected'))
				valid = false;
			end
		end
	end
end