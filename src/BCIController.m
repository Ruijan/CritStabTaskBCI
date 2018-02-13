classdef BCIController < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        input       = 0,
        inputMemory = [],
        loop,
        tobiICGet
    end
    
    methods
        function obj = BCIController(nLoop, nTobiICGet)
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.loop        = nLoop;
            obj.tobiICGet   = nTobiICGet;
        end

        function initController(obj)
            %obj.addPaths();

            % Connect to the CnbiTk loop
            if(obj.loop.connect() == false)
                error('BCIController:Connection', 'Cannot connect to CNBI Loop.')
            end 
            if(obj.tobiICGet.attach('/dev') == false)
                error('BCIController:TICConnection', 'Cannot connect to attach TobiIC to CNBI Loop.')
            end
        end

        function addPaths(obj)
            if(isempty(getenv('CNBITKMAT_ROOT')))
                disp('[ndf_include] $CNBITKMAT_ROOT not found, using default');
                setenv('CNBITKMAT_ROOT', '/usr/share/cnbiloop/cnbitkmat/');
            end
            if(isempty(getenv('EEGC3_ROOT')))
                disp('[ndf_include] $EEGC3_ROOT not found, using default');
                setenv('EEGC3_ROOT', '/opt/eegc3');
            end
            mtpath_root = [getenv('CNBITKMAT_ROOT') '/mtpath'];
            if(exist(mtpath_root, 'dir'))
                addpath(mtpath_root);
            end
            mtpath_include('$CNBITKMAT_ROOT/');
            mtpath_include('$EEGC3_ROOT/');
            mtpath_include('$EEGC3_ROOT/modules/smr');
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
                obj.input = obj.tobiICGet.getICMessage();
                obj.inputMemory = [obj.inputMemory obj.input];
                updated = true;
            end
        end

        function purge(obj)
            obj.inputMemory = [];
        end
    end
end

