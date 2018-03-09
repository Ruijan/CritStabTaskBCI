classdef DiscretizedVibroTactileFeedback < VibroTactileFeedback & handle
	properties 
		bins 		= 8,
		frequency 	= 10,
		stateBinSize
	end 

	methods 
		function obj = DiscretizedVibroTactileFeedback(system)
			obj@VibroTactileFeedback(system);
		end

		function init(obj)
			init@VibroTactileFeedback(obj);
			obj.stateBinSize = 2 * obj.system.boundary / obj.bins;
		end

		function update(obj)
			graphicalState = floor(obj.system.state / obj.stateBinSize + obj.bins / 2);
			fprintf(obj.arduinoDevice,'%u\n', graphicalState, 'sync');
		end
	end 
end 