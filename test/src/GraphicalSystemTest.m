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
            success = false;
            windowSize = [1680 1050];
            testCase.graphicalSystem.init(testCase.lambda, ...
                testCase.boundary,...
                testCase.gBoundary, ...
                testCase.timeLimit, ...
                testCase.engineMock.stub);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), windowSize);
            testCase.graphicalSystem.setInput(0.01);
            testCase.graphicalSystem.update(0.01);

            state       = testCase.boundary / exp(testCase.lambda*2)
            testCase.verifyEqual(testCase.graphicalSystem.input, 0.01);
            testCase.verifyEqual(testCase.graphicalSystem.state, exp(testCase.lambda*0.01) * state + (exp(testCase.lambda*0.01) - 1)*0.01);
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getWhiteIndex));
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getWindowSize));
            visualState = [testCase.graphicalSystem.state / testCase.boundary * windowSize(1) windowSize(2) / 2];
            testCase.verifyEqual(testCase.graphicalSystem.gState, visualState);
                % testCase.verifyCalled(testCase.graphicalSystem.engine.drawArc(IsAnything, IsAnything, IsAnything, [IsAnything]));
        end
    end
end