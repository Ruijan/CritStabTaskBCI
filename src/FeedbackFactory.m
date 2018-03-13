classdef FeedbackFactory < handle
	methods(Static)
		function feedback = createFeedback(varargin)
			p = inputParser;
			addRequired(p,'mode', @FeedbackFactory.isValidFeedback);
			addRequired(p,'system', @FeedbackFactory.isValidSystem);
			addOptional(p,'engine', NaN, @FeedbackFactory.isValidEngine);
			addOptional(p,'loop', NaN, @FeedbackFactory.isValidLoop);
			addOptional(p,'tobiIDSet', NaN, @FeedbackFactory.isValidTobiIDSet);
			addOptional(p,'bins', 8); %8 bins
			addOptional(p,'frequency', 2); %10 Hz
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Visual')
				disp('Create Visual Feedback');
				feedback = VisualFeedback(p.Results.engine, p.Results.system);
			elseif strcmp(p.Results.mode, 'DiscretizedVisual')
				disp('Create Discretized Visual Feedback');
				feedback = DiscretizedVisualFeedback(p.Results.engine, p.Results.system , p.Results.bins, p.Results.frequency);
			elseif strcmp(p.Results.mode, 'Connected')
				disp('Create Connected Feedback');
				feedback = ConnectedFeedback(p.Results.loop, p.Results.tobiIDSet, p.Results.system);
			elseif strcmp(p.Results.mode, 'VibroTactile')
				disp('Create Vibro Tactile Feedback');
				feedback = VibroTactileFeedback(p.Results.system);
			elseif strcmp(p.Results.mode, 'DiscretizedVibroTactile')
				disp('Create Vibro Tactile Feedback');
				feedback = DiscretizedVibroTactileFeedback(p.Results.system, p.Results.bins, p.Results.frequency);
			end
		end

		function valid = isValidFeedback(controllerMode)
			valid = true;
			if ~ischar(controllerMode) || (~strcmp(controllerMode,'Visual') && ...
				~strcmp(controllerMode,'DiscretizedVisual') && ...
				~strcmp(controllerMode,'Connected') && ...
				~strcmp(controllerMode,'VibroTactile') && ...
				~strcmp(controllerMode,'DiscretizedVibroTactile') && ...
				~strcmp(controllerMode,'None'))
				valid = false;
			end
		end

		function valid = isValidEngine(engine)
			valid = true;
			if ~strcmp(class(engine),'GraphicalEngine')
				valid = false;
			end
		end

		function valid = isValidSystem(unstableSystem)
			valid = true;
			if ~strcmp(class(unstableSystem),'System') && ~strcmp(class(unstableSystem),'GraphicalSystem')
				valid = false;
			end
		end

		function valid = isValidLoop(loop)
			valid = true;
			if ~strcmp(class(loop),'Loop') && ~isempty(loop)
				valid = false;
			end
		end

		function valid = isValidTobiIDSet(tobiIDSet)
			valid = true;
			if ~strcmp(class(tobiIDSet),'TobiIDSet') && ~isempty(tobiIDSet)
				valid = false;
			end
		end
	end
end