classdef LoopConfiguration < handle
	properties
		config
		taskset,
		exec,
		pipe,
		id,
		ic
	end
	methods
		function init(obj, loop)
			obj.config  = ccfg_new();
			modality 	= cl_retrieveconfig(loop.getLoop(), 'mi', 'modality');
			block    	= cl_retrieveconfig(loop.getLoop(), 'mi', 'block');
			taskset  	= cl_retrieveconfig(loop.getLoop(), 'mi', 'taskset');
			xmlfile     = cl_retrieveconfig(loop.getLoop(), 'mi', 'xml');
			pathToData  = cl_retrieveconfig(loop.getLoop(), 'mi', 'path');
			if(ccfg_importfile(obj.config, xmlfile) == 0)
				error(['Could not import file ' xmlfile]);
			end
			obj.taskset = ccfg_online(obj.config, block, taskset, icmessage_new(), idmessage_new());
			if(obj.taskset == 0)	
				error(['Could not configure online session']);
			end
			[obj.exec, obj.pipe, obj.id, obj.ic] = ccfgtaskset_getndf(obj.taskset);
			obj.throwIfPipeNotSet();
		end

		function throwIfPipeNotSet(obj)
			if isempty(obj.pipe)
				errorMessage = ['[ndf_mi] NDF configuration failed, killing matlab: \n' ...
					'  Pipename:   "' obj.pipe '"\n' ...
					'  iC address: "' obj.ic '"\n' ...
					'  iD address: "' obj.id '"'];
				error(errorMessage);
			end
		end
	end
end