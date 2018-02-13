%% Test Class Definition
classdef BCIControllerTest < matlab.mock.TestCase & handle
    properties
        controller
        ticMock
        loopMock
    end

    methods(TestMethodSetup)
        function createController(testCase)
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.ticMock = TobiICGetMock(testCase);
            testCase.loopMock = LoopMock(testCase);
            testCase.controller =  BCIController(testCase.loopMock.stub, ...
                testCase.ticMock.stub);
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
        function testBCIControllerCreation(testCase)

            testCase.verifyEqual(testCase.controller.input,         0);
            testCase.verifyEmpty(testCase.controller.inputMemory,   0);
            testCase.verifyEqual(testCase.controller.loop,   ...
                testCase.loopMock.stub);
            testCase.verifyEqual(testCase.controller.tobiICGet,   ...
                testCase.ticMock.stub);
        end

        function testFailedToConnectToLoopShouldThrow(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.connect), false)
            testCase.verifyError(@() testCase.controller.initController(), ...
                'BCIController:Connection');
        end

        function testFailedToAttachTICShouldThrow(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.connect), true)
            testCase.assignOutputsWhen(testCase.ticMock.behavior.attach('/dev'), false)
            testCase.verifyError(@() testCase.controller.initController(), ...
                'BCIController:TICConnection');
        end

        function testControllerInitialization(testCase)
            testCase.controller.initController();
            testCase.verifyEqual(getenv('CNBITKMAT_ROOT'), '/usr/share/cnbiloop/cnbitkmat/');
            testCase.verifyEqual(getenv('EEGC3_ROOT'), '/opt/eegc3');
            testCase.verifyCalled(withExactInputs(testCase.loopMock.behavior.connect));
            testCase.verifyCalled(testCase.ticMock.behavior.attach('/dev'));
        end

        function testControllerUpdateWithMessage(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.isConnected), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.isAttached), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.getMessage), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.getICMessage), '3.55')
            testCase.controller.initController();
            testCase.verifyEqual(testCase.controller.update(), true);
            testCase.verifyCalled(withExactInputs(testCase.loopMock.behavior.isConnected));
            testCase.verifyCalled(withExactInputs(testCase.ticMock.behavior.isAttached));
            testCase.verifyCalled(withExactInputs(testCase.ticMock.behavior.getMessage));
            testCase.verifyCalled(withExactInputs(testCase.ticMock.behavior.getICMessage));
            testCase.verifyEqual(testCase.controller.input, '3.55');
            testCase.verifyEqual(testCase.controller.inputMemory, ['3.55']);
        end

        function testControllerUpdateWithNoMessage(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.isConnected), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.isAttached), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.getMessage), false)
            testCase.controller.initController();
            testCase.verifyEqual(testCase.controller.update(), false);
            testCase.verifyCalled(withExactInputs(testCase.loopMock.behavior.isConnected));
            testCase.verifyCalled(withExactInputs(testCase.ticMock.behavior.isAttached));
            testCase.verifyCalled(withExactInputs(testCase.ticMock.behavior.getMessage));
            testCase.verifyNotCalled(withExactInputs(testCase.ticMock.behavior.getICMessage));
        end

        function testControllerUpdateLostConnection(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.isConnected), false)

            testCase.controller.initController();
            testCase.verifyError(@() testCase.controller.update(), 'BCIController:Connection');
        end

        function testControllerUpdateTICDetached(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.isConnected), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.isAttached), false)

            testCase.controller.initController();
            testCase.verifyError(@() testCase.controller.update(), 'BCIController:TICConnection');
        end

        function testControllerPurge(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.loopMock.behavior.isConnected), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.isAttached), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.getMessage), true)
            testCase.assignOutputsWhen(withExactInputs(testCase.ticMock.behavior.getICMessage), '3.55')
            testCase.controller.initController();
            testCase.controller.update();
            testCase.controller.purge();
            testCase.verifyEqual(length(testCase.controller.inputMemory), 0);
        end
    end
end