classdef DiscretizedVibroTactileFeedback < VibroTactileFeedback & handle
	properties 
		bins 			= 8,
		frequency 		= 10,
		stateBinSize 	= 0,
		previousUpdate 	= 0
	end 

	methods 
		function obj = DiscretizedVibroTactileFeedback(system, bins, frequency)
			obj@VibroTactileFeedback(system);
			obj.bins 		= bins;
			obj.frequency 	= frequency;
		end

		function init(obj)
			init@VibroTactileFeedback(obj);
			obj.stateBinSize = 2 * obj.system.boundary / obj.bins;
			obj.sendStateToArduino();
		end

		function update(obj, dt)
			obj.previousUpdate = obj.previousUpdate + dt;
			if obj.previousUpdate > 1 / obj.frequency
				obj.previousUpdate = 0;
				obj.sendStateToArduino();
			end
		end

		function sendStateToArduino(obj)
			graphicalState = floor((obj.system.state + obj.system.boundary) / obj.stateBinSize);
			obj.dataMessage(2) = graphicalState;
			obj.sendDataToDevice(obj.dataMessage, false);
		end
	end 
end 