classdef TaskRunnerFactoryTest < matlab.mock.TestCase & handle
	properties
		factory,
        runs = 4
        trialsPerRun = 25
	end
	methods(TestMethodSetup)
        function createTaskRunnerFactory(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.factory =  TaskRunnerFactory();
        end
    end
    methods (TestClassSetup)
        function setupPath(testCase)
            addpath([pwd '/../../src/']);
            addpath([pwd '/../../src/interfaces']);
            testCase.addTeardown(@rmpath,[pwd '/../../src/']);
        end
    end
    methods(Test)
    	function testTaskRunnerCreation(testCase)
    		taskRunner = testCase.factory.createTaskRunner('Simple', testCase.runs, testCase.trialsPerRun);
    		testCase.verifyEqual(class(taskRunner),'TaskRunner');
            testCase.verifyEqual(taskRunner.runs, testCase.runs);
            testCase.verifyEqual(taskRunner.trialsPerRun, testCase.trialsPerRun);
    	end

    	function testConnectedTaskRunnerCreation(testCase)
    		taskRunner = testCase.factory.createTaskRunner('BCI', testCase.runs, testCase.trialsPerRun);
    		testCase.verifyEqual(class(taskRunner),'ConnectedTaskRunner');
            testCase.verifyEqual(taskRunner.runs, testCase.runs);
            testCase.verifyEqual(taskRunner.trialsPerRun, testCase.trialsPerRun);
    	end

    	function testValidTaskRunner(testCase)
    		testCase.verifyEqual(testCase.factory.isValidTaskRunner('Simple'), true);
    		testCase.verifyEqual(testCase.factory.isValidTaskRunner('BCI'), true);
    	end
	end
end