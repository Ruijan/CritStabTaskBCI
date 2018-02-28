classdef CSTaskFactory < handle
	methods(Static)
		function task = createCSTask(varargin)
			p = inputParser;
			defaultEngine = [];
			addRequired(p,'mode', @CSTaskFactory.isValidCSTask);
			addRequired(p,'controller');
			addRequired(p,'system');
			addRequired(p,'difficultyUpdater');
			addRequired(p,'taskRunner');
			addOptional(p,'engine', defaultEngine);
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create visual task');
				timeProperties = TaskTimeProperties(9, 5, 3, 0, 0, 60);
				task = GraphicalCSTask(...
					timeProperties,...
					p.Results.controller,...
					p.Results.engine,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner);
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden task');
				timeProperties = TaskTimeProperties(9, 0, 0, 0, 0, 1000);
				task = CSTask(...
					timeProperties,...
					p.Results.controller,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner);
			end

		end

		function valid = isValidCSTask(taskMode)
			valid = true;
			if ~ischar(taskMode) || (~strcmp(taskMode,'Graphic') && ...
				~strcmp(taskMode,'None'))
				valid = false;
			end
		end
	end
end