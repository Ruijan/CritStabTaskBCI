classdef EEGRecorderTest < matlab.mock.TestCase & handle
	properties
		recorder,
        loopMock,
        loopConfigMock
	end
	methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.loopMock = LoopMock(testCase);
            testCase.loopConfigMock = LoopConfigurationMock(testCase);
            testCase.recorder =  EEGRecorder(...
                testCase.loopMock.stub, ...
                testCase.loopConfigMock.stub);
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
    		testCase.verifyEqual(testCase.recorder.data, struct('eeg', [], 'trigger', [], 'time', []));
    		testCase.verifyEqual(testCase.recorder.timestamp, []);
            testCase.verifyEqual(testCase.recorder.loop, testCase.loopMock.stub);
            testCase.verifyEqual(testCase.recorder.config, testCase.loopConfigMock.stub);
    	end

        function testFailedToConnectToLoopShouldThrow(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.connect), false)
            testCase.verifyError(@() testCase.recorder.init(), 'EEGRecorder:Connection');
        end
	end
end