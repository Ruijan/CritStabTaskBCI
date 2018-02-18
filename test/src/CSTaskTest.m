%% Test Class Definition
classdef CSTaskTest < matlab.mock.TestCase & handle
    properties
        task,
        controllerMock,
        runs = 4,
        trialsPerRun = 15,
        updateRate = 50,
        systemMock
    end

    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.controllerMock = ControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.task =  CSTask();

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
            testCase.verifyEqual(testCase.task.runs, 0);
            testCase.verifyEqual(testCase.task.trialsPerRun, 0);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
            testCase.verifyEqual(testCase.task.currentRun, 1);
        end

        function testCSTaskInitialization(testCase)
            testCase.initTask();

            testCase.verifyEqual(testCase.task.unstableSystem,   ...
                testCase.systemMock.stub);
            testCase.verifyEqual(testCase.task.controller,   ...
                testCase.controllerMock.stub);
            testCase.verifyEqual(testCase.task.runs, testCase.runs);
            testCase.verifyEqual(testCase.task.updateRate, testCase.updateRate);
            testCase.verifyEqual(testCase.task.trialsPerRun, testCase.trialsPerRun);
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.initController()));
        end

        function testCSTaskUpdate(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.controllerMock.behavior.update), true);
            testCase.assignOutputsWhen(get(testCase.controllerMock.behavior.input), 0.7);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyCalled(testCase.systemMock.behavior.setInput(0.7));
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testSystemDone(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.update();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testMaxRunReachedDone(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.task.currentRun = 5;
            testCase.task.update();
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
        end

        function testSwitchToNewRunAfterMaxTrialReached(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.currentRun = 1;
            testCase.task.currentTrial = 15;
            testCase.task.update();
            testCase.verifyEqual(testCase.task.currentRun, 2);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
        end

        function testLastTrialReached(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.task.currentRun = 4;
            testCase.task.currentTrial = 15;
            testCase.task.update();
            testCase.verifyEqual(testCase.task.currentRun, 5);
            testCase.verifyEqual(testCase.task.currentTrial, 1);
        end

        function testCSTaskPurge(testCase)
            testCase.initTask();
            testCase.task.purge();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.reset()));
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.purge()));
        end

        function testIsDone(testCase)
            testCase.initTask();
            testCase.task.currentRun = 5;
            testCase.verifyEqual(testCase.task.isDone(), true);
        end

        function testIsNotDone(testCase)
            testCase.initTask();
            testCase.task.currentRun = 4;
            testCase.verifyEqual(testCase.task.isDone(), false);
        end
    end
    methods
        function initTask(testCase)
            testCase.task.init(testCase.controllerMock.stub, ...
                testCase.systemMock.stub, ...
                testCase.runs, ...
                testCase.trialsPerRun, ...
                testCase.updateRate);
        end
    end
end