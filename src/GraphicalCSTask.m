classdef GraphicalCSTask < handle & CSTask
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
    end
    
    methods
        function obj = GraphicalCSTask(taskTimeProperties, controller, engine, nSystem, difficultyUpdater, taskRunner)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@CSTask(taskTimeProperties, controller, nSystem, difficultyUpdater, taskRunner);
            obj.feedbacks = VisualFeedback(engine, nSystem);
            obj.engine = engine;            
        end

        function init(obj)
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');
            obj.engine.openWindow(screenResolution - [1 1 1 1]);
            init@CSTask(obj);
        end

        function update(obj, dt)
            update@CSTask(obj, dt);
            obj.engine.updateScreen();
        end

        function updateTrial(obj, dt)
            updateTrial@CSTask(obj, dt);
        end

        function updateBreak(obj, dt)
            updateBreak@CSTask(obj, dt);
            if obj.currentTime < obj.taskTimeProperties.breakDuration
                outcome = 'Failure';
                if isempty(obj.taskRunner.results)
                    outcome = 'Unknown';
                elseif obj.taskRunner.results(end) == 1
                    outcome = 'Success';
                end
                obj.engine.drawText(['Break ' num2str(round(obj.currentTime,1)) '/'...
                        num2str(obj.taskTimeProperties.breakDuration) '\n Trial ' num2str(obj.taskRunner.currentTrial) '/'...
                        num2str(obj.taskRunner.trialsPerRun) '\n Difficulty ' num2str(obj.unstableSystem.lambda) ...
                        '\n Outcome : ' outcome], ...
                        obj.engine.getCenter() + [-150, -100], obj.engine.getWhiteIndex());
                if obj.engine.checkIfKeyPressed('ESCAPE')
                    obj.userDone = true;
                    return
                end
            end
        end

        function updateBaseline(obj, dt)
            updateBaseline@CSTask(obj, dt);
            if obj.currentTime < obj.taskTimeProperties.baselineDuration
                obj.engine.drawText('+', ...
                        obj.engine.getCenter() + [-150, -100], obj.engine.getWhiteIndex());
            end
        end

        function destroy(obj)
            obj.engine.closeAllWindows();
        end
    end
end

