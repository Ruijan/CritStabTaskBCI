classdef GraphicalCSTaskTest < matlab.mock.TestCase & handle
	properties
        runs = 4,
        trialsPerRun = 15,
        engineMock,
        controllerMock,
        systemMock,
        graphicalCSTask,
        updateRate = 50
    end
    methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock = GraphicalEngineMock(testCase);
            testCase.controllerMock = ControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.graphicalCSTask =  GraphicalCSTask();
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

            testCase.verifyEqual(testCase.graphicalCSTask.currentTrial, 1);
            testCase.verifyEqual(testCase.graphicalCSTask.currentRun, 1);
            
        end

        function testGraphicalCSTaskInitialization(testCase)
            testCase.initTask();
            screenResolution = get(0,'screensize');
            set(0,'units','pixels');
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.initController()));
            testCase.verifyCalled(testCase.systemMock.behavior.init(...
                1.5, screenResolution(1)*0.8, screenResolution(1)*0.8, 2, testCase.engineMock));
            testCase.verifyCalled(testCase.engineMock.behavior.openWindow(get(0,'screensize')));
            testCase.verifyEqual(testCase.graphicalCSTask.updateRate, testCase.updateRate);
            testCase.verifyEqual(testCase.graphicalCSTask.unstableSystem, testCase.systemMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.controller, testCase.controllerMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.engine, testCase.engineMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.runs, testCase.runs);
            testCase.verifyEqual(testCase.graphicalCSTask.trialsPerRun, testCase.trialsPerRun);
        end

        function testObjectDestruction(testCase)
            testCase.initTask();
            testCase.graphicalCSTask.destroy();
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.closeAllWindows()));
        end

        function testUpdate(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false)
            testCase.initTask();
            testCase.graphicalCSTask.update(0.01);
            testCase.verifyCalled(withExactInputs(testCase.engineMock.behavior.updateScreen()));
            testCase.verifyCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyCalled(withExactInputs(testCase.controllerMock.behavior.update()));
            testCase.verifyCalled(testCase.systemMock.behavior.update(0.01));
        end

        function testMaxRunReachedDone(testCase)
            testCase.initTask();
            testCase.assignOutputsWhen(withExactInputs(testCase.systemMock.behavior.exploded), false);
            testCase.graphicalCSTask.currentRun = 5;
            testCase.graphicalCSTask.update(0.01);
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.exploded()));
            testCase.verifyNotCalled(withExactInputs(testCase.systemMock.behavior.update()));
            testCase.verifyNotCalled(withExactInputs(testCase.engineMock.behavior.updateScreen()));
        end
    end
    methods
        function initTask(testCase)
            testCase.graphicalCSTask.init(testCase.controllerMock.stub, ...
                testCase.engineMock.stub, ...
                testCase.systemMock.stub, ...
                testCase.runs, ...
                testCase.trialsPerRun,...
                testCase.updateRate);
        end
    end
end