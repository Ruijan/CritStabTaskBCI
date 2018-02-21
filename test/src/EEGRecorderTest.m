classdef EEGRecorderTest < matlab.mock.TestCase & handle
	properties
		recorder,
        loopMock
	end
	methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.loopMock = LoopMock(testCase);
            testCase.recorder =  EEGRecorder(testCase.loopMock.stub);
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
    	function testEEGRecorderCreation(testCase)
    		testCase.verifyEqual(testCase.recorder.data, []);
    		testCase.verifyEqual(testCase.recorder.timestamp, []);
            testCase.verifyEqual(testCase.recorder.loop, testCase.loopMock.stub);
    	end

        function testFailedToConnectToLoopShouldThrow(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.connect), false)
            testCase.verifyError(@() testCase.recorder.init(), 'EEGRecorder:Connection');
        end
	end
end