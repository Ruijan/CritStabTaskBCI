classdef GraphicalEngineTest < matlab.mock.TestCase & handle
	properties
        windowSize = [0, 0, 960, 720],
        setup = 2,
        graphicalEngine
    end
    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.graphicalEngine = GraphicalEngine(testCase.setup);
        end
    end
    methods (TestClassSetup)
        function setupPath(testCase)
            addpath([pwd '/../../src/']);
            testCase.addTeardown(@rmpath,[pwd '/../../src/']);
        end
    end
    methods (Test)
        % includes unit test functions
        function testGraphicalEngineCreation(testCase)
            testCase.verifyEqual(testCase.graphicalEngine.setup, testCase.setup);
        end
        function testGraphicalEngineOpenWindow(testCase)
            testCase.graphicalEngine.openWindow(testCase.windowSize);
            testCase.verifyNotEmpty(testCase.graphicalEngine.window);
            testCase.verifyEqual(Screen('Rect', testCase.graphicalEngine.window), testCase.windowSize);
            sca;
        end

    end
end