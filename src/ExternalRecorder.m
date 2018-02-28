classdef ExternalRecorder < handle
	properties
		data = [],
		recorderProperties
	end
	methods(Abstract)
		update(obj)
		init(obj)
		purge(obj)
	end
end