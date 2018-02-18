classdef ControllerEvaluator < handle

	methods(Static)
		function channelCapacity = evaluate(states, inputs)
			channelCapacity 	= 0;
			stateSides 			= states > 0;
			stateSides 			= stateSides(1:end-1);
			inputSides 			= inputs > 0;
			inputSides 			= inputSides(1:end-1);
			stateSpeed 			= diff(states);
			stateAcceleration	= diff(stateSpeed);
			
			correctPattern 		= (stateSpeed > 0 & stateSides == 0) | ...
									(stateSpeed < 0 & stateSides == 1); 
			trueInput = [stateSides(correctPattern); ~stateSides(~correctPattern)];
			% trueInput = stateSides;
			[confusionMatrix, ~] = ControllerEvaluator.confmat(inputSides, trueInput);
			error0 = confusionMatrix(1,2);
			error1 = confusionMatrix(2,1);
			channelCapacity = ControllerEvaluator.computeChannelCapacity(error0/2, error1/2);
		end

		function channelCapacity = computeChannelCapacity(error0, error1)
			if error0 > 0.5
				error0 = 1 - error0;
			end
			if error1 > 0.5
				error1 = 1 - error1;
			end
			
			channelCapacity = 0;
			if ~(error0 == error1 && error0 == 0.5)
				Hb0 = 0;
				Hb1 = 0;
				if error0 ~= 0
					Hb0 = - error0 * log2(error0) - (1 - error0) * log2(1 - error0);
				end
				if error1 ~= 0
					Hb1 = - error1 * log2(error1) - (1 - error1) * log2(1 - error1);
				end
				if isnan(error0)
					channelCapacity = NaN;
				elseif isnan(error1)
					channelCapacity = NaN;
				else
					denominator = (1 - error0 - error1);
					channelCapacity = ...
						error0 / denominator * Hb1 - ...
						(1 - error1) / denominator * Hb0 + ...
						log2(1 + 2 ^ ((Hb0 - Hb1) / denominator));
				end
			end
		end

		function [conf,rate]=confmat(Y,T)
			%CONFMAT Compute a confusion matrix.
			%
			%	Description
			%	[CONF, RATE] = CONFMAT(Y, T) computes the confusion matrix C and
			%	classification performance RATE for the predictions Y compared
			%	with the targets T. Y and T both should be column or both should be 
			%	row vectors.
			%
			%	In the confusion matrix, the rows represent the true classes and the
			%	columns the predicted classes.  The vector RATE has two entries: the
			%	percentage of correct classifications and the total number of correct
			%	classifications.
			%
			%	Rajen Bhatt,
			%   Indian Institute of Technology Delhi

			if length(Y)~=length(T) 
			   error('Outputs and targets are different lengths')
			end

			c = [0, 1];

			for i = 1:length(c)
			   for j = 1:length(c)
			      conf(i,j) = sum((Y==c(j)).*(T==c(i)))/sum(T == c(i));
			   end
			end

			correct = (Y == T);

			rate=(sum(correct)/length(correct)) * 100;
		end
	end

end