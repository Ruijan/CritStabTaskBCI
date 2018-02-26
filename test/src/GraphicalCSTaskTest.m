classdef GraphicalCSTaskTest < matlab.mock.TestCase & handle
	properties
        taskRunnerMock,
        engineMock,
        controllerMock,
        systemMock,
        difficultyUpdaterMock,
        graphicalCSTask,
        updateRate = 50
    end
    methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock     = GraphicalEngineMock(testCase);
            testCase.controllerMock = ControllerMock(testCase);
            testCase.systemMock     = SystemMock(testCase);
            testCase.taskRunnerMock = TaskRunnerMock(testCase);
            testCase.difficultyUpdaterMock = DifficultyUpdaterMock(testCase);
            testCase.graphicalCSTask =  GraphicalCSTask(...
                testCase.controllerMock.stub, ...
                testCase.engineMock.stub, ...
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
        function testGraphicalCSTaskCreation(testCase)
            testCase.verifyEqual(testCase.graphicalCSTask.updateRate, testCase.updateRate);
            testCase.verifyEqual(testCase.graphicalCSTask.unstableSystem, testCase.systemMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.controller, testCase.controllerMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.engine, testCase.engineMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.difficultyUpdater, testCase.difficultyUpdaterMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.taskRunner, testCase.taskRunnerMock.stub);
        end

        function testGraphicalCSTaskInitialization(testCase)
            import matlab.unittest.constraints.IsAnything;
            testCase.initTask();
            screenResolution = get(0,'screensize');
            set(0,'units','pixels');
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.initController()));
            testCase.verifyCalled(testCase.engineMock.behavior.openWindow(IsAnything));
            testCase.verifyCalled(testCase.systemMock.behavior.init(...
                1.5, screenResolution(3)*0.4, screenResolution(3)*0.4, 2, IsAnything));
        end

        function testObjectDestruction(testCase)
            testCase.initTask();
            testCase.graphicalCSTask.destroy();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.closeAllWindows()));
        end

        function testUpdate(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), true)
            testCase.initTask();
            testCase.graphicalCSTask.updateTask(0.01);
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.updateScreen()));
        end
    end
    methods 

        function initTask(testCase)
            testCase.assignOutputsWhen(get(testCase.taskRunnerMock.behavior.results), [])
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getCenter), [250 250])
            testCase.graphicalCSTask.init();
        end
    end 
end