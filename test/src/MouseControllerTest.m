%% Test Class Definition
classdef MouseControllerTest < matlab.mock.TestCase & handle
    properties
        controller,
        engineMock
    end

    methods(TestMethodSetup)
        function createController(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock = GraphicalEngineMock(testCase);
            testCase.controller =  MouseController(testCase.engineMock.stub);
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
        function testMouseControllerCreation(testCase)
            testCase.verifyEqual(testCase.controller.input,         0);
            testCase.verifyEmpty(testCase.controller.inputMemory,   0);
            testCase.verifyEqual(testCase.controller.engine,   ...
                testCase.engineMock.stub);
        end

        function testMouseControllerInit(testCase)
            minInput = 0;
            maxInput = 1920;
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0 0 maxInput 1080]);
            testCase.controller.initController();
            testCase.verifyEqual(testCase.controller.minInput, minInput);
            testCase.verifyEqual(testCase.controller.maxInput, maxInput);
        end

        function testMouseControllerUpdate(testCase)
            minInput = 0;
            maxInput = 1920;
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0 0 maxInput 1080]);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getMousePosition), [250, 350]);
            updated = testCase.controller.update();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getMousePosition()));
            testCase.verifyEqual(updated, true);
            testCase.verifyEqual(testCase.controller.input, 250);
            testCase.verifyEqual(testCase.controller.inputMemory, [250]);
        end

        function testMouseControllerUpdateWithLowerInput(testCase)
            minInput = 0;
            maxInput = 1920;
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0 0 maxInput 1080]);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getMousePosition), [-200, 350]);
            updated = testCase.controller.update();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getMousePosition()));
            testCase.verifyEqual(updated, true);
            testCase.verifyEqual(testCase.controller.input, 0);
            testCase.verifyEqual(testCase.controller.inputMemory, [0]);
        end

        function testMouseControllerUpdateWithHigherInput(testCase)
            minInput = 0;
            maxInput = 1920;
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0 0 maxInput 1080]);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getMousePosition), [maxInput + 200, 350]);
            updated = testCase.controller.update();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getMousePosition()));
            testCase.verifyEqual(updated, true);
            testCase.verifyEqual(testCase.controller.input, maxInput);
            testCase.verifyEqual(testCase.controller.inputMemory, [maxInput]);
        end
    end
end