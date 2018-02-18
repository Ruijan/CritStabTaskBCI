classdef CSTaskFactory < handle
	methods(Static)
		function task = createCSTask(varargin)
			p = inputParser;
			addRequired(p,'mode', @CSTaskFactory.isValidCSTask);
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create visual task');
				task = GraphicalCSTask();
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden task');
				task = CSTask();
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