classdef BCIController < handle & Controller
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        loop,
        tobiICGet
    end
    
    methods
        function obj = BCIController(loop, tobiICGet)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            minProbability = 0;
            maxProbability = 1;
            obj@Controller(minProbability, maxProbability);
            obj.loop        = loop;
            obj.tobiICGet   = tobiICGet;
        end

        function initController(obj)

            % Connect to the CnbiTk loop
            obj.checkLoopConnection();
            obj.checkTICAttached();
        end
        
        function updated = update(obj, dt)
            updated = false;
            obj.checkLoopConnection();
            obj.checkTICAttached();
            if obj.tobiICGet.getMessage()
                obj.input = obj.tobiICGet.getProbability();
                obj.inputMemory = [obj.inputMemory obj.input];
                updated = true;
            end
        end
        function checkLoopConnection(obj)
            if(obj.loop.isConnected() == false)
                if(obj.loop.connect() == false)
                    error('BCIController:Connection', 'Cannot connect to CNBI Loop.')
                else
                    warning('Had to reconnect to loop.')
                end
            end 
        end
        function checkTICAttached(obj)
            if(obj.tobiICGet.isAttached() == false)
                if(obj.tobiICGet.attach('/ctrl1') == false)
                    error('BCIController:TICConnection', 'Cannot connect to attach TobiIC to CNBI Loop.')
                else
                    warning('Had to reattach TobiIC to loop.')
                end
            end 
        end
    end
end

