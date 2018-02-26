%% Test Class Definition
classdef CSTaskTest < matlab.mock.TestCase & handle
    properties
        task,
        controllerMock,
        runs = 4,
        trialsPerRun = 15,
        updateRate = 50,
        systemMock,
        recorderMock,
        taskRunnerMock,
        difficultyUpdaterMock
    end

    methods(TestMethodSetup)
        function createTask(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.controllerMock = ControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.recorderMock = ExternalRecorderMock(testCase);
            testCase.taskRunnerMock = TaskRunnerMock(testCase);
            testCase.difficultyUpdaterMock = DifficultyUpdaterMock(testCase);
            testCase.task =  CSTask(testCase.controllerMock.stub, ...
                testCase.systemMock.stub, ...
                testCase.difficultyUpdaterMock.stub, ...
                testCase.taskRunnerMock.stub, ...
                testCase.updateRate);

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
            testCase.verifyEqual(testCase.task.controllerITR, 0);
            testCase.verifyEqual(testCase.task.ITRMemory, []);
            testCase.verifyEqual(testCase.task.maxTimePerTrial, 10);
            testCase.verifyEqual(testCase.task.currentTime, 0);
            testCase.verifyEqual(testCase.task.userDone, false);
            testCase.verifyEqual(testCase.task.unstableSystem, testCase.systemMock.stub);
            testCase.verifyEqual(testCase.task.controller, testCase.controllerMock.stub);
            testCase.verifyEqual(testCase.task.taskRunner, testCase.taskRunnerMock.stub);
            testCase.verifyEqual(testCase.task.difficultyUpdater, testCase.difficultyUpdaterMock.stub);
            testCase.verifyEqual(testCase.task.updateRate, testCase.updateRate);
        end

        function testCSTaskInitialization(testCase)
            testCase.initTask();

            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.initController()));
        end

        function testAddRecorder(testCase)
            testCase.initTask();
            testCase.task.addRecorder(testCase.recorderMock.stub);
            testCase.verifyEqual(length(testCase.task.recorders), 1);
            testCase.verifyEqual(testCase.task.recorders(end), testCase.recorderMock.stub)
        end

        function testCSTaskUpdate(testCase)
            import matlab.mock.constraints.WasCalled;
            testCase.initTask();
            dt = 0.01;
            testCase.task.addRecorder(testCase.recorderMock.stub);
            testCase.task.addRecorder(testCase.recorderMock.stub);
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.taskRunnerMock.behavior.isDone), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.controllerMock.behavior.update), true);
            testCase.assignOutputsWhen(get(testCase.controllerMock.behavior.input), 0.7);
            testCase.assignOutputsWhen(get(testCase.controllerMock.behavior.minInput), 100);
            testCase.assignOutputsWhen(get(testCase.controllerMock.behavior.maxInput), 200);
            testCase.task.update(dt);
            testCase.verifyCalled(testCase.systemMock.behavior.update(dt));
            testCase.verifyCalled(testCase.systemMock.behavior.setInput(0.7, 100, 200));
            testCase.verifyThat(withExactInputs(testCase.recorderMock.behavior.update()), WasCalled('WithCount',2));
        end

        function testSystemDone(testCase)
            import matlab.unittest.constraints.IsAnything;
            testCase.initTask();
            testCase.task.addRecorder(testCase.recorderMock.stub);
            testCase.task.addRecorder(testCase.recorderMock.stub);
            testCase.assignOutputsWhen(withExactInputs(testCase.taskRunnerMock.behavior.isDone), false);
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true);
            testCase.assignOutputsWhen(withExactInputs(testCase.taskRunnerMock.behavior.shouldSwitchRun), true);
            testCase.task.update(0.01);
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(testCase.systemMock.behavior.update(0.01));
            testCase.verifyCalled(testCase.taskRunnerMock.behavior.update(IsAnything));
            testCase.verifyCalled(testCase.difficultyUpdaterMock.behavior.update(IsAnything, IsAnything));
            testCase.verifyCalled(withExactInputs(testCase.difficultyUpdaterMock.behavior.getNewDifficulty()));
            testCase.verifyCalled(withExactInputs(testCase.taskRunnerMock.behavior.shouldSwitchRun()));
            testCase.verifyCalled(withExactInputs(testCase.taskRunnerMock.behavior.switchRun()));
        end

        function testCSTaskPurge(testCase)
            testCase.initTask();
            testCase.task.purge();
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.reset()));
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.purge()));
        end

        function testIsDone(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.taskRunnerMock.behavior.isDone), true);
            testCase.verifyEqual(testCase.task.isDone(), true);
        end

        function testIsNotDone(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.taskRunnerMock.behavior.isDone), false);
            testCase.verifyEqual(testCase.task.isDone(), false);
        end
    end
    methods
        function initTask(testCase)
            testCase.task.init();
        end
    end
end