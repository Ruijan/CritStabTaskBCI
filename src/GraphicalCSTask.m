classdef GraphicalCSTask < handle & CSTask
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
        trialBreakTime  = 5.0 %s
        fixationTime    = 3.0 %s
        runBreakTime    = 300 %s
    end
    
    methods
        function obj = GraphicalCSTask(controller, engine, nSystem, difficultyUpdater, taskRunner, updateRate)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@CSTask(controller, nSystem, difficultyUpdater, taskRunner, updateRate);
            obj.engine = engine;            
        end

        function init(obj)
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');
            obj.engine.openWindow(screenResolution - [1 1 1 1]);
            obj.unstableSystem.init(1.5, screenResolution(3)*0.4, screenResolution(3)*0.4, 2, obj.engine);
            init@CSTask(obj);
        end
        function start(obj)
            obj.pauseTask(2.0);
            obj.purge();
            start@CSTask(obj);
        end

        function updateTask(obj, dt)
            updateTask@CSTask(obj, dt);
            obj.engine.updateScreen();
            if obj.engine.checkIfKeyPressed('S')
                obj.unstableSystem.showInput = ~obj.unstableSystem.showInput;
                return
            end
        end

        function switchTrial(obj, dt)
            obj.pauseTask(obj.trialBreakTime);
            switchTrial@CSTask(obj, dt);
            obj.startFixationPeriod();
        end

        function switchRun(obj, dt)
            obj.pauseTask(obj.runBreakTime);
            switchRun@CSTask(obj, dt);
        end

        function pauseTask(obj, breakTime)
            tic;
            currentTime = toc;
            outcome = 'Failure';
            if isempty(obj.taskRunner.results)
                outcome = 'Unknown';
            elseif obj.taskRunner.results(end) == 1
                outcome = 'Success';
            end
            while currentTime < breakTime
                obj.engine.drawText(['Break ' num2str(round(currentTime,1)) '/'...
                        num2str(breakTime) '\n Trial ' num2str(obj.taskRunner.currentTrial) '/'...
                        num2str(obj.taskRunner.trialsPerRun) '\n Difficulty ' num2str(obj.unstableSystem.lambda) ...
                        '\n Outcome : ' outcome], ...
                        obj.engine.getCenter() + [-150, -100], obj.engine.getWhiteIndex());
                if obj.engine.checkIfKeyPressed('ESCAPE')
                    obj.userDone = true;
                    return
                end
                obj.engine.updateScreen();
                currentTime = toc;
            end
        end

        function startFixationPeriod(obj)
            tic;
            currentTime = toc;
            while currentTime < obj.fixationTime
                obj.engine.drawText('+', ...
                        obj.engine.getCenter() + [-150, -100], obj.engine.getWhiteIndex());
                obj.engine.updateScreen();
                obj.updateRecorders();
                currentTime = toc;
            end
        end

        function destroy(obj)
            obj.engine.closeAllWindows();
        end
    end
end

