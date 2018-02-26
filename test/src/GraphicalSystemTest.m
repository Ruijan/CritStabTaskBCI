classdef GraphicalSystemTest < matlab.mock.TestCase & handle
	properties
		lambda 		= 2.5,
		boundary 	= 10,
		gBoundary 	= 0.8,
        timeLimit   = 2,
        engineMock,
        graphicalSystem
    end
    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock = GraphicalEngineMock(testCase);
            testCase.graphicalSystem = GraphicalSystem();
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
            testCase.verifyEqual(testCase.graphicalSystem.gBoundary,   ...
                0);
            testCase.verifyEqual(testCase.graphicalSystem.gState,   ...
                0);
        end

        function testGrahicalSystemInit(testCase)
            testCase.graphicalSystem.init(testCase.lambda, ...
                testCase.boundary,...
                testCase.gBoundary, ...
                testCase.timeLimit, ...
                testCase.engineMock.stub);
            testCase.verifyEqual(testCase.graphicalSystem.lambda,   ...
                testCase.lambda);
            testCase.verifyEqual(testCase.graphicalSystem.boundary,   ...
                testCase.boundary);
            testCase.verifyEqual(testCase.graphicalSystem.gBoundary,   ...
                testCase.gBoundary);
            testCase.verifyEqual(testCase.graphicalSystem.engine,   ...
                testCase.engineMock.stub);
        end

        function testGraphicalSystemUpdate(testCase)
            import matlab.unittest.constraints.IsAnything;
            testCase.graphicalSystem.init(testCase.lambda, ...
                testCase.boundary,...
                testCase.gBoundary, ...
                testCase.timeLimit, ...
                testCase.engineMock.stub);

            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0 0 1920 1050])
            testCase.graphicalSystem.update(0.01)
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getWindowSize));
            testCase.verifyCalled(testCase.engineMock.behavior.drawArc(IsAnything, IsAnything, IsAnything, IsAnything, IsAnything));
            testCase.verifyCalled(testCase.engineMock.behavior.drawFilledRect(IsAnything, IsAnything, IsAnything));
            testCase.verifyCalled(testCase.engineMock.behavior.drawFilledRect(IsAnything, IsAnything, IsAnything));

        end
    end
end