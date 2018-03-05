classdef TaskTimeProperties < handle
	properties
		trialDuration       = 10, % second
		startBreakDuration  = 1.5, % second
        breakDuration       = 5.0, % second
        baselineDuration    = 3.0, % second
        switchTrialDuration = 0, % second
        switchRunDuration   = 0, % second
        updateRate          = 60, % Hz
        precision 			= 0.01 % 1 percent precision
	end 
	methods 
		function obj = TaskTimeProperties(varargin)
			p = inputParser;
			addOptional(p,'trialDuration', 10, @TaskTimeProperties.isValidDuration);
			addOptional(p,'startBreakDuration', 10, @TaskTimeProperties.isValidDuration);
			addOptional(p,'breakDuration', 0, @TaskTimeProperties.isValidDuration);
			addOptional(p,'baselineDuration', 0, @TaskTimeProperties.isValidDuration);
			addOptional(p,'switchTrialDuration', 0, @TaskTimeProperties.isValidDuration);
			addOptional(p,'switchRunDuration', 0, @TaskTimeProperties.isValidDuration);
			addOptional(p,'updateRate', 0, @TaskTimeProperties.isValidDuration);
			parse(p,varargin{:});
			obj.trialDuration 		= p.Results.trialDuration;
			obj.startBreakDuration 	= p.Results.startBreakDuration;
			obj.breakDuration 		= p.Results.breakDuration;
			obj.baselineDuration 	= p.Results.baselineDuration;
			obj.switchTrialDuration = p.Results.switchTrialDuration;
			obj.switchRunDuration 	= p.Results.switchRunDuration;
			obj.updateRate 			= p.Results.updateRate;
		end
	end 

	methods(Static)
		function valid = isValidDuration(duration)
			valid = isnumeric(duration) && isscalar(duration) && (duration >= 0);
		end
	end 
end