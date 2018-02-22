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
            obj@Controller();
            obj.loop        = loop;
            obj.tobiICGet   = tobiICGet;
        end

        function initController(obj)

            % Connect to the CnbiTk loop
            if(obj.loop.connect() == false)
                error('BCIController:Connection', 'Cannot connect to CNBI Loop.')
            end 
            if(obj.tobiICGet.attach('/ctrl1') == false)
                error('BCIController:TICConnection', 'Cannot connect to attach TobiIC to CNBI Loop.')
            end
        end
        
        function updated = update(obj)
            updated = false;
            if(obj.loop.isConnected() == false)
                error('BCIController:Connection', 'Lost connection with CNBI Loop.')
            end 
            if(obj.tobiICGet.isAttached() == false)
                error('BCIController:TICConnection', 'TobiICGet is not attached to the loop anymore.')
            end 
            if obj.tobiICGet.getMessage()
                obj.input = obj.tobiICGet.getProbability();
                obj.inputMemory = [obj.inputMemory obj.input];
                updated = true;
            end
        end
    end
end

