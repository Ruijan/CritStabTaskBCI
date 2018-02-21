classdef ExternalRecorderTest < matlab.mock.TestCase & handle
	properties
		recorder
	end
	methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.recorder =  ExternalRecorder();
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
    	function testExternalRecorderCreation(testCase)
    		testCase.verifyEqual(testCase.recorder.data, []);
    		testCase.verifyEqual(testCase.recorder.timestamp, []);
    	end
	end
end