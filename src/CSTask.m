classdef CSTask < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bciController,
        unstableSystem,
        runs            = 0,
        trialsPerRun    = 0,
        currentTrial    = 1,
        currentRun      = 1
    end
    
    methods
        function obj = CSTask(nBciController, bSystem, runs, trialsPerRun)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.bciController       = nBciController;
            obj.unstableSystem      = bSystem;
            obj.runs                = runs;
            obj.trialsPerRun        = trialsPerRun;
        end

        function init(obj)
            obj.bciController.initController();
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

