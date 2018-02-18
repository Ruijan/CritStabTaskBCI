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

        function init(obj, controller, engine, bSystem, runs, trialsPerRun, updateRate)
            disp('Init Task')
            obj.updateRate          = updateRate;
            obj.controller          = controller;
            obj.unstableSystem      = bSystem;
            obj.runs                = runs;
            obj.trialsPerRun        = trialsPerRun;
            obj.engine              = engine;
            set(0,'units','pixels');
            screenResolution = get(0,'screensize')
            obj.engine.openWindow(screenResolution);
            if strcmp(class(obj.controller), 'MouseController')
                obj.controller.initController(engine)
            else
                obj.controller.initController();
            end
            obj.unstableSystem.init(1.5, ...
                screenResolution(3)*0.4, screenResolution(3)*0.4, 2, obj.engine);

            obj.pauseTask(2);
            obj.purge();
        end

        function updateTask(obj, dt)
            updateTask@CSTask(obj, dt);
            obj.engine.updateScreen();
        end

        function switchTrial(obj, dt)
            obj.pauseTask(5);
            switchTrial@CSTask(obj, dt);
        end

        function pauseTask(obj, pauseTime)
            tic;
            currentTime = toc;
            while currentTime < pauseTime
                obj.engine.drawText(['Break ' num2str(round(currentTime,1)) '/'...
                        num2str(pauseTime) '\n Trial ' num2str(obj.currentTrial) '/'...
                        num2str(obj.trialsPerRun)], obj.engine.getCenter() + [-150, -100], obj.engine.getWhiteIndex());
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

