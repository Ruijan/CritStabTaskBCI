classdef GraphicalSystemTest < matlab.mock.TestCase & handle
	properties
		lambda 		= 2.5,
		boundary 	= 10,
		gBoundary 	= 0.8,
        graphicalSystem
    end
    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;

            testCase.graphicalSystem = GraphicalSystem(testCase.lambda, testCase.boundary, testCase.gBoundary);
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
        % includes unit test functions
        function testGraphicalSystemCreation(testCase)
            testCase.verifyEqual(testCase.graphicalSystem.lambda,   ...
                testCase.lambda);
            testCase.verifyEqual(testCase.graphicalSystem.boundary,   ...
                testCase.boundary);
            testCase.verifyEqual(testCase.graphicalSystem.gBoundary,   ...
                testCase.gBoundary);
        end
        function testGraphicalSystemInit(testCase)
            success = false;
            try
                testCase.graphicalSystem.init();
                success = true;
            catch e
                disp(e)
            end
            testCase.verifyEqual(success, true);
        end
    end
end