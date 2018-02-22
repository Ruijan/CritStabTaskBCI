classdef CSTask < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller,
        unstableSystem,
        difficultyUpdater,
        taskRunner,
        controllerITR   = 0,
        ITRMemory       = [],
        updateRate      = 60,
        maxTimePerTrial = 10,
        currentTime     = 0,
        userDone        = false
    end
    
    methods
        function obj = CSTask()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
        end

        function init(obj, controller, nSystem, difficultyUpdater, taskRunner, updateRate)
            disp('Init CSTTask');
            obj.initParameters(controller, nSystem, difficultyUpdater, taskRunner, updateRate);
            obj.controller.initController();

        end

        function initParameters(obj, controller, System, difficultyUpdater, runs, trialsPerRun, updateRate)
            obj.updateRate          = updateRate;
            obj.controller          = controller;
            obj.unstableSystem      = System;
            obj.difficultyUpdater   = difficultyUpdater;
            obj.taskRunner          = taskRunner;
        end

        function start(obj)
            disp('Start Task')
            tic;
            while ~obj.isDone()
                elapsedTimeInSeconds  = toc;
                if elapsedTimeInSeconds > 1/obj.updateRate
                    disp('Update Task');
                    obj.update(elapsedTimeInSeconds);
                    tic;
                end
            end
        end

        function update(obj, dt)
            disp('Update CSTTask');
            if ~obj.isDone()
                obj.updateTask(dt);
            end
        end

        function updateTask(obj, dt)
            if ~obj.unstableSystem.exploded() && obj.currentTime < obj.maxTimePerTrial
                obj.runTrial(dt);
            else
                outcome = obj.getOutcome();
                obj.taskRunner.update(outcome);
                obj.switchTrial(dt);
                % We need to send the opposite command because it is the opposite of a detection task
                obj.difficultyUpdater.update(obj.unstableSystem.lambda, ~outcome);
                obj.unstableSystem.lambda = obj.difficultyUpdater.getNewDifficulty();
                if obj.taskRunner.shouldSwitchRun()
                    obj.switchRun(dt);
                end
            end
        end

        function outcome = getOutcome(obj)
            if obj.currentTime >= obj.maxTimePerTrial
                outcome = 1;
            else
                outcome = 0;
            end
        end

        function runTrial(obj, dt)
            if(obj.controller.update())
                obj.unstableSystem.setInput(obj.controller.input);
            end
            obj.unstableSystem.update(dt);
            obj.computeITR();
            obj.currentTime = obj.currentTime + dt;
            disp(['Current time : ' num2str(obj.currentTime) '/' num2str(obj.maxTimePerTrial)])
            disp(['Current ITR : ' num2str(obj.controllerITR)])
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

        function switchTrial(obj, dt)
            obj.save();
            obj.purge();
            obj.taskRunner.switchTrial();
            obj.currentTime     = 0;
        end

        function switchRun(obj, dt)
            obj.taskRunner.switchRun();
        end

        function purge(obj)
            obj.controller.purge();
            obj.unstableSystem.reset();
            obj.controllerITR = 0;
        end

        function save(obj)
            trial = struct('Controller', struct(obj.controller), 'System', ...
                struct(obj.unstableSystem), 'TaskRunner', obj.taskRunner, 'ITR', obj.ITRMemory);
            save(['Run_' num2str(obj.taskRunner.currentRun) '_Trial_' ...
                num2str(obj.taskRunner.currentTrial)], 'trial');
        end

        function done = isDone(obj)
            done = obj.userDone || obj.taskRunner.isDone();
        end

        function destroy(obj)

        end
    end
end

