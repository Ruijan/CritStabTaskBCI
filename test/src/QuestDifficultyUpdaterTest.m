classdef QuestDifficultyUpdaterTest < matlab.mock.TestCase & handle

	properties
		updater
	end
	methods(TestMethodSetup)
        function createUpdater(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.updater = QuestDifficultyUpdater(3.5, 5, 1.5, 0.8, 3.5, 0.99, 0.51);
        end
    end
    methods (TestClassSetup)
        function setupPath(testCase)
            addpath([pwd '/../../src/']);
            testCase.addTeardown(@rmpath,[pwd '/../../src/']);
        end
    end
        %% Test Method Block
    methods (Test)
		function testEvaluatorCreation(testCase)
        end

        function testInit(testCase)
            testCase.verifyEqual(testCase.updater.prior, 3.5);
            testCase.verifyEqual(testCase.updater.maxValue, 5);
            testCase.verifyEqual(testCase.updater.priorStd, 1.5);
            testCase.verifyEqual(testCase.updater.probThreshold, 0.8);
            testCase.verifyEqual(testCase.updater.sigmoidSlope, 3.5);
            testCase.verifyEqual(testCase.updater.maxProbability, 0.99);
            testCase.verifyEqual(testCase.updater.chanceLevel, 0.51);
        end

        function testUpdate(testCase)
            x = 0:0.1:10;
            y = sigmf(x,[2 4]);
            for step = 1:300
                lambda = testCase.updater.getNewDifficulty();
                prob = y(abs(x - round(lambda,1)) < 0.001);
                response = rand() < prob;
                testCase.updater.update(lambda, response);
            end
            testCase.verifyEqual(abs(lambda - 4.75) < 0.15, true)
        end
	end
end