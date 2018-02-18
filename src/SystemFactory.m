classdef SystemFactory < handle
	methods(Static)
		function newSystem = createSystem(varargin)
			p = inputParser;
			addRequired(p,'mode', @SystemFactory.isValidSystem);
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create visual system');
				newSystem = GraphicalSystem();
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden system');
				newSystem = System();
			end

		end

		function valid = isValidSystem(systemMode)
			valid = true;
			if ~ischar(systemMode) || (~strcmp(systemMode,'Graphic') && ...
				~strcmp(systemMode,'None'))
				valid = false;
			end
		end
	end
end