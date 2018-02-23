classdef GraphicalCSTask < handle & CSTask
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
    end
    
    methods
        function obj = GraphicalCSTask()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@CSTask();
            
        end

        function init(obj, controller, engine, nSystem, difficultyUpdater, taskRunner, updateRate)
            disp('Init Task')

            obj.initParameters(controller, engine, nSystem, difficultyUpdater, taskRunner, updateRate);
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');

            obj.engine.openWindow(screenResolution - [1 1 1 1]);

            obj.unstableSystem.init(1.5, ...
                screenResolution(3)*0.4, screenResolution(3)*0.4, 2, obj.engine);

            obj.pauseTask(2);
            obj.purge();
        end

        function initParameters(obj, controller, engine, nSystem, difficultyUpdater, taskRunner, updateRate)
            initParameters@CSTask(obj, controller, nSystem, difficultyUpdater, taskRunner, updateRate);
            obj.engine = engine;
        end

        function updateTask(obj, dt)
            updateTask@CSTask(obj, dt);
            obj.engine.updateScreen();
        end

        function switchTrial(obj, dt)
            obj.pauseTask(5);
            switchTrial@CSTask(obj, dt);
        end

        function switchRun(obj, dt)
            switchRun@CSTask(obj, dt);

        end

        function pauseTask(obj, pauseTime)
            tic;
            currentTime = toc;
            while currentTime < pauseTime
                outcome = 'Failure';
                if isempty(obj.taskRunner.results)
                    outcome = 'Unknown';
                elseif obj.taskRunner.results(end) == 1
                    outcome = 'Success';
                end
                obj.engine.drawText(['Break ' num2str(round(currentTime,1)) '/'...
                        num2str(pauseTime) '\n Trial ' num2str(obj.taskRunner.currentTrial) '/'...
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

        function destroy(obj)
            disp('Destroy GraphicalCSTask');
            obj.engine.closeAllWindows();
        end
    end
end

