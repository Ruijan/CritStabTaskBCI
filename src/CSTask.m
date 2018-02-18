classdef CSTask < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        controller,
        unstableSystem,
        controllerITR   = 0,
        runs            = 0,
        trialsPerRun    = 0,
        currentTrial    = 1,
        currentRun      = 1,
        updateRate      = 60,
        maxTimePerTrial = 10,
        currentTime     = 0,
        results         = [],
        ITRMemory       = []
    end
    
    methods
        function obj = CSTask()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
        end

        function init(obj, controller, bSystem, runs, trialsPerRun, updateRate)
            disp('Init CSTTask');
            obj.initParameters(controller, bSystem, runs, trialsPerRun, updateRate);
            obj.controller.initController();
        end

        function initParameters(obj, controller, bSystem, runs, trialsPerRun, updateRate)
            obj.updateRate          = updateRate;
            obj.controller          = controller;
            obj.unstableSystem      = bSystem;
            obj.runs                = runs;
            obj.trialsPerRun        = trialsPerRun;
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
                obj.saveSuccess();
                obj.switchTrial(dt);
                if obj.shouldSwitchRun()
                    obj.switchRun(dt);
                end
            end
        end

        function saveSuccess(obj)
            if obj.currentTime >= obj.maxTimePerTrial
                obj.results = [obj.results 1];
            else
                obj.results = [obj.results 0];
            end
        end

        function runTrial(obj, dt)
            if(obj.controller.update())
                obj.unstableSystem.setInput(obj.controller.input);
            end
            obj.unstableSystem.update(dt);
            period = 64;
            if length(obj.unstableSystem.stateMemory) - 1 < period
                period = length(obj.unstableSystem.stateMemory) - 1;
            end
            if length(obj.unstableSystem.stateMemory) > 10
                obj.controllerITR = ControllerEvaluator.evaluate(...
                    obj.unstableSystem.stateMemory(end-period:end), ...
                    obj.unstableSystem.inputMemory(end-period:end));
                obj.ITRMemory = [obj.ITRMemory obj.controllerITR];
                        %  * ...
                        % (obj.unstableSystem.timeMemory(end) - obj.unstableSystem.timeMemory(end-32));
            end
            obj.currentTime = obj.currentTime + dt;
            disp(['Current time : ' num2str(obj.currentTime) '/' num2str(obj.maxTimePerTrial)])
            disp(['Current ITR : ' num2str(obj.controllerITR)])
        end

        function switchTrial(obj, dt)
            obj.save();
            obj.purge();
            obj.currentTrial    = obj.currentTrial + 1;
            obj.currentTime     = 0;
        end

        function switchRun(obj, dt)
            obj.currentRun      = obj.currentRun + 1;
            obj.currentTrial    = 1;
        end

        function purge(obj)
            obj.controller.purge();
            obj.unstableSystem.reset();
            obj.controllerITR = 0;
        end

        function save(obj)
            trial = struct('Controller', struct(obj.controller), 'System', struct(obj.unstableSystem), 'Results', obj.results, 'ITR', obj.ITRMemory);
            save(['Trial_' num2str(obj.currentTrial)], 'trial');
        end

        function shouldSwitch = shouldSwitchRun(obj)
            shouldSwitch = obj.currentTrial > obj.trialsPerRun;
        end

        function done = isDone(obj)
            done = obj.currentRun > obj.runs;
        end
        function destroy(obj)

        end
    end
end

