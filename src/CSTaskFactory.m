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
				task = GraphicalCSTask(...
					p.Results.controller,...
					p.Results.engine,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner,...
					60);
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden task');
				task = CSTask(p.Results.controller,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner,...
					60);
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