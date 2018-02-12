classdef CSTask < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bciController,
        unstableSystem
    end
    
    methods
        function obj = CSTask(nBciController, bSystem)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.bciController       = nBciController;
            obj.unstableSystem      = bSystem;
        end
        function init(obj)
            obj.bciController.initController();
        end

        function update(obj)
            if ~obj.unstableSystem.exploded()
                if(obj.bciController.update())
                    obj.unstableSystem.setInput(obj.bciController.input);
                end
                obj.unstableSystem.update();
            end
        end
    end
end

