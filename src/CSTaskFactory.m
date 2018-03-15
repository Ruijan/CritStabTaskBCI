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
			addRequired(p,'taskTimeProperties');
			addOptional(p,'engine', defaultEngine);
			
			parse(p,varargin{:});
			if strcmp(p.Results.mode, 'Graphic')
				disp('Create visual task');
				task = GraphicalCSTask(...
					p.Results.taskTimeProperties,...
					p.Results.controller,...
					p.Results.engine,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner);
			elseif strcmp(p.Results.mode, 'None')
				disp('Create hidden task');
				task = CSTask(...
					p.Results.taskTimeProperties,...
					p.Results.controller,...
					p.Results.system, ...
					p.Results.difficultyUpdater, ...
					p.Results.taskRunner);
			end

		end

		function task = createCSTaskFromParameters(params)
			if (strcmp(params.controller, 'Mouse') || strcmp(params.controller, 'BCI') || ...
				strcmp(params.controller, 'Training')) && ~strcmp(params.display, 'Graphic')
				params.display = 'Graphic';
			end
			engine 		= [];
			loop 		= [];
			tobiIDSet 	= [];
			tobiICGet 	= [];
			feedbacks 	= [];
			if strcmp(params.display, 'Graphic')
				engine 	= GraphicalEngine(2);
			end
			
			newSystem 	= SystemFactory.createSystem(params.display, engine);
			if strcmp(params.taskRunner, 'Connected')
				Loop.addPaths();
				loop 		= Loop();
				tobiIDSet 	= TobiIDSet(loop);
			end
			if strcmp(params.controller, 'BCI')
				tobiICGet 	= TobiICGet(loop);
			end			
			controller 		= ControllerFactory.createController(...
				params.controller, engine, newSystem, loop, tobiICGet);
			taskRunner 		= TaskRunnerFactory.createTaskRunner(params.taskRunner, ...
				params.runs, params.trialsPerRun, loop, tobiIDSet);
			difficultyUpdater 	= [];
			timeProperties 		= [];
			if strcmp(params.controller, 'BCI')
				difficultyUpdater 	= QuestDifficultyUpdater(0.5, 1.5, 0.75, 0.75, 3.5, 0.99, 0.01);
				timeProperties 		= TaskTimeProperties(9, 1.5, 5, 3, 0, 0, 50);
			elseif strcmp(params.controller, 'Mouse')
				difficultyUpdater 	= QuestDifficultyUpdater(3.0, 5, 1.5, 0.75, 3.5, 0.99, 0.01);
				timeProperties 		= TaskTimeProperties(9, 0, 5, 0, 0, 0, 50);
			elseif strcmp(params.controller, 'Training')
				difficultyUpdater 	= VectorDifficultyUpdater([1.5], [1]);
				timeProperties 		= TaskTimeProperties(30, 1, 5, 3, 0, 0, 50);
			end

			task = CSTaskFactory.createCSTask(params.display, controller, newSystem, ...
				difficultyUpdater, taskRunner, timeProperties, engine);
			
			for feedbackIndex = 1:length(params.feedbacks)
				task.addFeedback(FeedbackFactory.createFeedback(...
					params.feedbacks{feedbackIndex}, ...
					newSystem, ...
					engine, ...
					loop, ...
					tobiIDSet, ...
					params.bins, ...
					params.frequency));
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