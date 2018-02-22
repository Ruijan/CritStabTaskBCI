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
			loop.cfg.taskset  = cl_retrieveconfig(obj.getLoop(), 'mi', 'taskset');
			[obj.cfg.exec, obj.cfg.pipe, obj.cfg.id, loop.cfg.ic] = ...
				ccfgtaskset_getndf(loop.cfg.taskset);

			
			if isempty(loop.cfg.pipe)
				errorMessage = ['[ndf_mi] NDF configuration failed, killing matlab: \n' ...
					'  Pipename:   "' loop.cfg.pipe '"\n' ...
					'  iC address: "' loop.cfg.ic '"\n' ...
					'  iD address: "' loop.cfg.id '"'];
				error(errorMessage);
			end
			ndf = obj.createNDF();
			disp('[ndf_mi] Receiving ACK...');
			[ndf.conf, ndf.size] = ndf_ack(ndf.sink);
			obj.initBuffer();
			disp('[ndf_mi] Receiving NDF frames...');
			loop.jump.tic = ndf_tic();
		end

		function update(obj)
			loop.jump.toc = ndf_toc(loop.jump.tic);
			loop.jump.tic = ndf_tic();
			[ndf.frame, ndf.size] = ndf_read(ndf.sink, ndf.conf, ndf.frame);
			buffer.tim = ndf_add2buffer(buffer.tim, ndf_toc(ndf.frame.timestamp));
			buffer.eeg = ndf_add2buffer(buffer.eeg, ndf.frame.eeg);
			%buffer.exg = ndf_add2buffer(buffer.exg, ndf.frame.exg);
			buffer.tri = ndf_add2buffer(buffer.tri, ndf.frame.tri);
			data = [data buffer];
		end

		function initBuffer(obj)
			buffer.eeg = ndf_ringbuffer(ndf.conf.sf, ndf.conf.eeg_channels, 1.00);
			buffer.tri = ndf_ringbuffer(ndf.conf.sf, ndf.conf.tri_channels, 1.00);
			buffer.tim = ndf_ringbuffer(ndf.conf.sf/ndf.conf.samples, ndf.conf.tim_channels, 5.00);
		end

		function purge(obj)
			obj.initBuffer();
			data = [];
		end

		function ndf = createNDF(obj)
			ndf.conf  = {};
			ndf.size  = 0;
			ndf.frame = ndf_frame();
			ndf.sink  = ndf_sink(loop.cfg.ndf.pipe);
		end
	end
end