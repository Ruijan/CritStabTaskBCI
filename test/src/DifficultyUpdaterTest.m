classdef DifficultyUpdaterTest < matlab.mock.TestCase & handle

	properties
		updater
	end
	methods(TestMethodSetup)
        function createUpdater(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.updater = DifficultyUpdater();
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
	end
end