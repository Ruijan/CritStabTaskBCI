classdef QuestDifficultyUpdater < handle & DifficultyUpdater
	properties
		quest = []
		prior
		maxValue,
		priorStd,
		probThreshold,
		sigmoidSlope,
		chanceLevel,
		maxProbability
	end

	methods
		function obj = QuestDifficultyUpdater(prior, maxValue, priorStd, probThreshold, sigmoidSlope, maxProbability, chanceLevel)
			obj.prior 			= prior;
			obj.maxValue 		= maxValue;
			obj.priorStd 		= priorStd;
			obj.sigmoidSlope 	= sigmoidSlope;
			obj.probThreshold 	= probThreshold;
			obj.maxProbability 	= maxProbability;
			obj.chanceLevel 	= chanceLevel;
			obj.quest 			= QuestCreate(...
				log(obj.prior./obj.maxValue),...
				obj.priorStd,...
				obj.probThreshold,...
				obj.sigmoidSlope,...
				1-obj.maxProbability,...
				obj.chanceLevel);
		end

		function update(obj, testedValue, response)
			obj.quest = QuestUpdate(obj.quest,log(testedValue./obj.maxValue), response);
		end
		function lambda = getNewDifficulty(obj)
			lambda = obj.maxValue.*exp(QuestMean(obj.quest));
		end
	end

end