classdef DiscretizedPneumaticVibroTactileFeedback < PneumaticVibroTactileFeedback & handle
	properties 
		bins 			= 8,
		frequency 		= 10,
		stateBinSize 	= 0,
		previousUpdate 	= 0
	end 

	methods 
		function obj = DiscretizedPneumaticVibroTactileFeedback(system, bins, frequency)
			obj@PneumaticVibroTactileFeedback(system);
			obj.bins 		= bins;
			obj.frequency 	= frequency;
		end

		function init(obj)
			init@PneumaticVibroTactileFeedback(obj);
			obj.stateBinSize = 2 * obj.system.boundary / obj.bins;
			obj.sendDiscretizedStateToDevice();
		end

		function update(obj, dt)
			obj.previousUpdate = obj.previousUpdate + dt;
			if obj.previousUpdate > 1 / obj.frequency
				obj.previousUpdate = 0;
				obj.sendDiscretizedStateToDevice();
			end
		end

		function sendDiscretizedStateToDevice(obj)
			graphicalState = floor((obj.system.state + obj.system.boundary) / obj.stateBinSize)
			obj.sendStateToDevice(graphicalState);
		end
	end 
end 