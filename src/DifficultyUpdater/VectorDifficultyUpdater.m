classdef VectorDifficultyUpdater < handle & DifficultyUpdater
	properties
		values,
		weights
	end

	methods
		function obj = VectorDifficultyUpdater(values, varargin)
			p = inputParser;
			addRequired(p,'values');
			addOptional(p,'weights', []);
			parse(p, values, varargin{:});
			obj.weights = 1/length(p.Results.values) * ones(length(p.Results.values));
			obj.values = p.Results.values;
			if length(p.Results.weights) == length(p.Results.values)
				obj.weights = p.Results.weights / sum(p.Results.weights);				
			end
		end

		function update(obj, testedValue, response)
		end
		
		function lambda = getNewDifficulty(obj)
			index 	= find(rand(1)<=cumsum(obj.weights),1);
			lambda 	= obj.values(index);
		end
	end
end