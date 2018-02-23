classdef EEGRecorder < ExternalRecorder & handle
	properties 
		loop
		jump
		config
		ndf
	end
	methods 
		function obj = EEGRecorder(loop, config)
			obj@ExternalRecorder();
			obj.loop = loop;
			obj.config = config;
			obj.data = struct('eeg', [], 'trigger', [], 'time', []);
		end

		function init(obj)
			% Connect to the CnbiTk loop
            if(obj.loop.connect() == false)
                error('EEGRecorder:Connection', 'Cannot connect to CNBI Loop.')
            end 
            obj.jump = ndf_jump();
            obj.config.init(obj.loop);
			obj.createNDF();
			disp('[ndf_mi] Receiving ACK...');
			[obj.ndf.conf, obj.ndf.size] = ndf_ack(obj.ndf.sink);
			disp('[ndf_mi] Receiving NDF frames...');
			obj.jump.tic = ndf_tic();
		end

		function update(obj)
			obj.jump.toc = ndf_toc(obj.jump.tic);
			obj.jump.tic = ndf_tic();
			[obj.ndf.frame, obj.ndf.size] = ndf_read(obj.ndf.sink, obj.ndf.conf, obj.ndf.frame);
			ndf_toc(obj.ndf.frame.timestamp);

			obj.data.eeg 		= [obj.data.eeg; obj.ndf.frame.eeg];
			obj.data.trigger 	= [obj.data.trigger; obj.ndf.frame.tri];
			obj.data.time 		= [obj.data.time; obj.ndf.frame.timestamp];
		end

		function purge(obj)
			obj.initBuffer();
			obj.data = struct('eeg', [], 'trigger', [], 'time', []);
		end

		function createNDF(obj)
			obj.ndf.conf  = {};
			obj.ndf.size  = 0;
			obj.ndf.frame = ndf_frame();
			obj.ndf.sink  = ndf_sink('/tmp/cl.pipe.ndf.2');
		end
	end
end