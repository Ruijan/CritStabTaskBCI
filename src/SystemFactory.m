classdef SystemFactory < handle
	methods(Static)
		function newSystem = createSystem(varargin)
			p = inputParser;
			addRequired(p,'mode', @SystemFactory.isValidSystem);
			addOptional(p,'engine', @SystemFactory.isValidEngine);
			parse(p,varargin{:});
			set(0,'units','pixels');
            screenResolution = get(0,'screensize');
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create Visual System');
				newSystem = GraphicalSystem(1.5, screenResolution(3)*0.4, ...
					screenResolution(3)*0.4, 4, p.Results.engine);
			elseif strcmp(p.Results.mode, 'None')
				disp('Create Hidden System');
				newSystem = System(1.5, screenResolution(3)*0.4, 4);

			end

		end

		function valid = isValidSystem(systemMode)
			valid = true;
			if ~ischar(systemMode) || (~strcmp(systemMode,'Graphic') && ...
				~strcmp(systemMode,'None'))
				valid = false;
			end
		end
		function valid = isValidEngine(engine)
			valid = true;
			if ~strcmp(engine,'GraphicalEngine')
				valid = false;
			end
		end
	end
end