classdef EEGRecorder < ExternalRecorder & handle
	properties 
		loop
		jump
		config
	end
	methods 
		function obj = EEGRecorder(loop)
			obj@ExternalRecorder();
			obj.loop = loop;
		end

		function init(obj)
			% Connect to the CnbiTk loop
            if(obj.loop.connect() == false)
                error('EEGRecorder:Connection', 'Cannot connect to CNBI Loop.')
            end 
            obj.jump = ndf_jump();
			obj.cfg  = ccfg_new();
		end
	end
end