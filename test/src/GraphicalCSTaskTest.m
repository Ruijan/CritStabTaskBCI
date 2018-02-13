classdef GraphicalCSTaskTest < matlab.mock.TestCase & handle
	properties
        runs = 4,
        trialsPerRun = 15,
        engineMock,
        bciControllerMock,
        systemMock,
        graphicalCSTask
    end
    methods(TestMethodSetup)
        function createGraphicalCSTask(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock = GraphicalEngineMock(testCase);
            testCase.bciControllerMock = BCIControllerMock(testCase);
            testCase.systemMock = SystemMock(testCase);
            testCase.graphicalCSTask =  GraphicalCSTask(...
                testCase.bciControllerMock.stub, ...
                testCase.systemMock.stub, ...
                testCase.runs, ...
                testCase.trialsPerRun,...
                testCase.engineMock.stub);
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
            testCase.verifyEqual(testCase.graphicalCSTask.unstableSystem,   ...
                testCase.systemMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.bciController,   ...
                testCase.bciControllerMock.stub);
            testCase.verifyEqual(testCase.graphicalCSTask.runs, testCase.runs);
            testCase.verifyEqual(testCase.graphicalCSTask.trialsPerRun, testCase.trialsPerRun);
            testCase.verifyEqual(testCase.graphicalCSTask.currentTrial, 1);
            testCase.verifyEqual(testCase.graphicalCSTask.currentRun, 1);
            testCase.verifyEqual(testCase.graphicalCSTask.engine,   ...
                testCase.engineMock.stub);
        end

        function testGraphicalCSTaskInit(testCase)
            testCase.graphicalCSTask.init();
            set(0,'units','pixels');
            testCase.verifyCalled(withExactInputs(testCase.bciControllerMock.behavior.initController()));
            testCase.verifyCalled(testCase.engineMock.behavior.openWindow(get(0,'screensize')));
        end
    end
end