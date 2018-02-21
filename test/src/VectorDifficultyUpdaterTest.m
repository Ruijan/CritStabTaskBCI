classdef VectorDifficultyUpdaterTest < matlab.mock.TestCase & handle

	properties
		updater
	end
	methods(TestMethodSetup)
        function createUpdater(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.updater = VectorDifficultyUpdater();
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
            values = [0.1 0.5 0.8 0.9 1.5 2.0];
            testCase.updater.init(values);
            testCase.verifyEqual(testCase.updater.values, values)
            testCase.verifyEqual(testCase.updater.values, values)
        end

        function testUpdateWithoutWeight(testCase)
            values = [0.1 0.5 0.8 0.9 1.5 2.0];
            testCase.updater.init(values);
            occurences = zeros(length(values),1);
            iterations = 500;
            for step = 1:iterations
                lambda = testCase.updater.getNewDifficulty();
                occurences(values == lambda) = occurences(values == lambda) + 1;
                response = rand() < 0.5;
                testCase.updater.update(lambda, response);
            end
            [h,p,ci,stats] = ttest2(occurences, ones(length(occurences),1) * iterations/length(values));
            testCase.verifyEqual(h, 0);
        end

        function testUpdateWithWeight(testCase)
            values = [0.1   0.5 0.8 0.9 1.5 2.0];
            weigths = [5     5   30  15  5   60];
            testCase.updater.init(values, weigths);
            occurences = zeros(length(values),1);
            iterations = 500;
            for step = 1:iterations
                lambda = testCase.updater.getNewDifficulty();
                occurences(values == lambda) = occurences(values == lambda) + 1;
                response = rand() < 0.5;
                testCase.updater.update(lambda, response);
            end
            [h2,p2,ci,stats] = ttest2(occurences, weigths);
            testCase.verifyEqual(h2, 0);
        end
	end
end