classdef ExternalRecorder < handle
	properties
		data = [],
		timestamp = []
	end
	methods(Abstract)
		update(obj)
		init(obj)
		purge(obj)
	end
end