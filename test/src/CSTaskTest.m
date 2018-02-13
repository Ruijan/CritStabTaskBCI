%% Test Class Definition
classdef CSTaskTest < matlab.mock.TestCase & handle
    properties
        task,
        bciControllerMock,
        runs = 4,
        trialsPerRun = 15,
        systemMock
    end

    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.bciControllerMock = BCIControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.task =  CSTask(testCase.bciControllerMock.stub, ...
                testCase.systemMock.stub, testCase.runs, testCase.trialsPerRun);

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
                testCase.bciControllerMock.stub);
            testCase.verifyEqual(testCase.task.runs, testCase.runs);
            testCase.verifyEqual(testCase.task.trialsPerRun, testCase.trialsPerRun);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
            testCase.verifyEqual(testCase.task.currentRun, 1);
        end

        function testCSTaskInit(testCase)
            testCase.task.init();
            testCase.verifyCalled(withExactInputs(testCase.bciControllerMock.behavior.initController()));
        end

        function testCSTaskUpdate(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.bciControllerMock.behavior.update), true);
            testCase.assignOutputsWhen(get(testCase.bciControllerMock.behavior.input), 0.7);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyCalled(testCase.systemMock.behavior.setInput(0.7));
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testSystemDone(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testMaxRunReachedDone(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.task.currentRun = 5;
            testCase.task.update();
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testSwitchToNewRunAfterMaxTrialReached(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.currentRun = 1;
            testCase.task.currentTrial = 15;
            testCase.task.update();
            testCase.verifyEqual(testCase.task.currentRun, 2);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
        end

        function testLastTrialReached(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.currentRun = 4;
            testCase.task.currentTrial = 15;
            testCase.task.update();
            testCase.verifyEqual(testCase.task.currentRun, 5);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
        end

        function testCSTaskPurge(testCase)
            testCase.task.purge();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.reset()));
            testCase.verifyCalled(withExactInputs(testCase.bciControllerMock.behavior.purge()));
        end
    end
end