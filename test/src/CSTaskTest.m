%% Test Class Definition
classdef CSTaskTest < matlab.mock.TestCase & handle
    properties
        task,
        bCIControllerMock,
        systemMock
    end

    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.bCIControllerMock = BCIControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.task =  CSTask(testCase.bCIControllerMock.stub, ...
                testCase.systemMock.stub);

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
        function testCSTaskCreation(testCase)
            testCase.verifyEqual(testCase.task.unstableSystem,   ...
                testCase.systemMock.stub);
            testCase.verifyEqual(testCase.task.bciController,   ...
                testCase.bCIControllerMock.stub);
        end

        function testCSTaskInit(testCase)
            testCase.task.init();
            testCase.verifyCalled(withExactInputs(testCase.bCIControllerMock.behavior.initController()));
        end

        function testCSTaskUpdate(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.bCIControllerMock.behavior.update), true);
            testCase.assignOutputsWhen(get(testCase.bCIControllerMock.behavior.input), 0.7);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyCalled(testCase.systemMock.behavior.setInput(0.7));
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testCSTaskDone(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end
    end
end