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
            testCase.controller =  MouseController();
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
        end

        function testMouseControllerInit(testCase)
            testCase.controller.initController(testCase.engineMock.stub);
            testCase.verifyEqual(testCase.controller.engine,   ...
                testCase.engineMock.stub);
        end

        function testMouseControllerUpdate(testCase)
            testCase.controller.initController(testCase.engineMock.stub);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getMousePosition), [250, 350]);
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getCenter), [150, 200]);
            updated = testCase.controller.update();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getMousePosition()));
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.getCenter()));
            testCase.verifyEqual(updated, true);
            testCase.verifyEqual(testCase.controller.input, 100);
            testCase.verifyEqual(testCase.controller.inputMemory, [100]);
        end
    end
end