classdef CSTask < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller,
        unstableSystem,
        difficultyUpdater,
        taskRunner,
        taskTimeProperties,
        state,
        feedbacks       = [],
        recorders       = [],
        controllerITR   = 0, % bits/second
        ITRMemory       = [],
        currentTime     = 0, % second
        userDone        = false   
    end
    properties (Constant)
        Created         = 0, 
        Initialized     = 1, 
        Baseline        = 2, 
        RunTrial        = 3, 
        Break           = 4, 
        SwitchTrial     = 5, 
        SwitchRun       = 6
    end
    
    methods
        function obj = CSTask(taskTimeProperties, controller, nSystem, difficultyUpdater, taskRunner)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.taskTimeProperties  = taskTimeProperties;
            obj.controller          = controller;
            obj.unstableSystem      = nSystem;
            obj.difficultyUpdater   = difficultyUpdater;
            obj.taskRunner          = taskRunner;
            obj.state               = CSTask.Created;
        end

        function init(obj)
            disp('Init CSTTask');
            obj.controller.initController();
            obj.unstableSystem.init();
            obj.taskRunner.init();
            obj.state = CSTask.Initialized;
            for feedbackIndex = 1:length(obj.feedbacks)
                obj.feedbacks(feedbackIndex).init();
            end
        end

        function addRecorder(obj, recorder)
            obj.recorders = [obj.recorders recorder];
        end

        function addFeedback(obj, feedback)
            obj.feedbacks = [obj.feedbacks feedback];
        end

        function start(obj)
            if obj.state~= CSTask.Initialized 
                error('Task should be initialized first');
            end
            expectedElapsedTime = 1 / obj.taskTimeProperties.updateRate;
            tic;
            while ~obj.isDone()
                elapsedTimeInSeconds  = toc;
                if elapsedTimeInSeconds > expectedElapsedTime
                    tic;
                    obj.update(elapsedTimeInSeconds);
                    obj.currentTime = obj.currentTime + elapsedTimeInSeconds;
                    obj.throwWarningIfSlowDown(elapsedTimeInSeconds, expectedElapsedTime);
                end
            end
        end

        function update(obj, dt)
            switch obj.state
                case CSTask.Baseline
                    obj.updateBaseline(dt);
                case CSTask.RunTrial
                    obj.updateTrial(dt);
                case CSTask.Break
                    obj.updateBreak(dt);
                case CSTask.SwitchTrial 
                    obj.updateSwitchTrial(dt);
                case CSTask.SwitchRun
                    obj.updateSwitchRun(dt);
                otherwise
                    obj.state = CSTask.Baseline;
            end
        end

        function throwWarningIfSlowDown(obj, elapsedTimeInSeconds, expectedElapsedTime)
            if((elapsedTimeInSeconds - expectedElapsedTime)/(expectedElapsedTime) > ...
                obj.taskTimeProperties.precision)
                warning(['Program is running slower than expected: ' ...
                    num2str(round(1/elapsedTimeInSeconds)) 'Hz instead of ' ...
                    num2str(round(obj.taskTimeProperties.updateRate)) 'Hz in state : ' num2str(obj.state)])
            end
        end


        function updateBaseline(obj, dt)
            if obj.currentTime < obj.taskTimeProperties.baselineDuration
                obj.updateRecorders();
            else
                obj.purge();
                obj.state = CSTask.RunTrial;
                obj.taskRunner.startTrial(dt);
                obj.currentTime     = 0;
            end
        end

        function updateTrial(obj, dt)
            if ~obj.unstableSystem.exploded() && obj.currentTime < obj.taskTimeProperties.trialDuration
                if(obj.controller.update(dt))
                    obj.unstableSystem.setInput(obj.controller.input, obj.controller.minInput, obj.controller.maxInput);
                end
                if obj.currentTime > obj.taskTimeProperties.startBreakDuration
                    obj.unstableSystem.update(dt);
                end
                obj.updateRecorders();
                obj.computeITR();
                for feedbackIndex = 1:length(obj.feedbacks)
                    obj.feedbacks(feedbackIndex).update();
                end
                % disp(['Current time : ' num2str(obj.currentTime) '/' num2str(obj.trialDuration)])
                % disp(['Current ITR : ' num2str(obj.controllerITR)])
            else
                for feedbackIndex = 1:length(obj.feedbacks)
                    obj.feedbacks(feedbackIndex).endTrial();
                end
                outcome = obj.getOutcome();
                obj.taskRunner.endTrial(outcome);
                % We need to send the opposite command because it is the opposite of a detection task
                obj.difficultyUpdater.update(obj.unstableSystem.lambda, ~outcome);
                obj.unstableSystem.lambda = obj.difficultyUpdater.getNewDifficulty();
                obj.save();
                obj.currentTime     = 0;
                obj.state           = CSTask.Break;
                obj.taskRunner.startBreak(dt);
            end
        end

        function updateBreak(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.breakDuration
                obj.taskRunner.switchTrial(dt);
                obj.state = CSTask.SwitchTrial;
                obj.currentTime     = 0;
            end
        end

        function updateSwitchTrial(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.switchTrialDuration
                if obj.taskRunner.shouldSwitchRun()
                    obj.taskRunner.switchRun();
                    obj.state = CSTask.SwitchRun;
                else
                    obj.taskRunner.startBaseline();
                    obj.state = CSTask.Baseline;
                end
                obj.currentTime     = 0;
            end
        end

        function updateSwitchRun(obj, dt)
            if obj.currentTime > obj.taskTimeProperties.switchRunDuration
                obj.taskRunner.startBaseline(dt);
                obj.state = CSTask.Baseline;
                obj.currentTime     = 0;
            end
        end

        function outcome = getOutcome(obj)
            if obj.currentTime >= obj.taskTimeProperties.trialDuration
                outcome = 1;
            else
                outcome = 0;
            end
        end

        function computeITR(obj)
            period = 64;
            if length(obj.unstableSystem.stateMemory) - 1 < period
                period = length(obj.unstableSystem.stateMemory) - 1;
            end
            if length(obj.unstableSystem.stateMemory) > 10
                obj.controllerITR = ControllerEvaluator.evaluate(...
                    obj.unstableSystem.stateMemory(end-period:end), ...
                    obj.unstableSystem.inputMemory(end-period:end));
                obj.ITRMemory = [obj.ITRMemory obj.controllerITR];
            end
        end

        function purge(obj)
            obj.controller.purge();
            obj.unstableSystem.reset();
            for recorderIndex = 1:length(obj.recorders)
                obj.recorders(recorderIndex).purge();
            end 
            obj.controllerITR   = 0;
            obj.ITRMemory       = [];
        end

        function save(obj)
            trial = struct('Controller', obj.controller, ...
                'System', obj.unstableSystem, ...
                'TaskRunner', obj.taskRunner, ...
                'ITR', obj.ITRMemory);
            for recorderIndex = 1:length(obj.recorders)
                % We need to remove chararacters from struct fieldnames that could be mistaken as commands
                disp('Add EEG data to trial')
                recorderName = (class(obj.recorders(recorderIndex)));
                recorderName(recorderName == '.') = '';
                trial.(recorderName) = obj.recorders(recorderIndex).data;
            end
            save(['Run_' num2str(obj.taskRunner.currentRun) '_Trial_' ...
                num2str(obj.taskRunner.currentTrial)], 'trial');
        end

        function done = isDone(obj)
            done = obj.userDone | obj.taskRunner.isDone();
        end

        function updateRecorders(obj)
            for recorderIndex = 1:length(obj.recorders)
                obj.recorders(recorderIndex).update();
            end
        end

        function destroy(obj)
            obj.controller.destroy();
            obj.taskRunner.destroy();
        end
    end
end