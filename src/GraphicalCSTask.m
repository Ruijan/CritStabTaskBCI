classdef GraphicalCSTask < handle & CSTask
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        engine
    end
    
    methods
        function obj = GraphicalCSTask(nBciController, ...
            bSystem, runs, trialsPerRun, engine)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj@CSTask(nBciController, bSystem, runs, trialsPerRun);
            obj.engine = engine;
        end

        function init(obj)
            init@CSTask(obj);
            set(0,'units','pixels');
            screenResolution = get(0,'screensize');
            obj.engine.openWindow(screenResolution);
        end

        function update(obj)
            if obj.currentRun <= obj.runs
                if ~obj.unstableSystem.exploded()
                    if(obj.bciController.update())
                        obj.unstableSystem.setInput(obj.bciController.input);
                    end
                    obj.unstableSystem.update();
                end
                obj.currentTrial    = obj.currentTrial + 1;
                if obj.shouldSwitchRun()
                    obj.currentRun      = obj.currentRun + 1;
                    obj.currentTrial    = 1;
                end
            end
        end

        function purge(obj)
            obj.bciController.purge();
            obj.unstableSystem.reset();
        end

        function shouldSwitch = shouldSwitchRun(obj)
            shouldSwitch = obj.currentTrial > obj.trialsPerRun;
        end
    end
end

