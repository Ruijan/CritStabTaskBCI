classdef ControllerFactoryTest < matlab.mock.TestCase & handle
	properties
		factory
        engineMock
	end
	methods(TestMethodSetup)
        function createControllerFactory(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.engineMock = GraphicalEngineMock(testCase);
            testCase.factory =  ControllerFactory();
        end
    end
    methods (TestClassSetup)
        function setupPath(testCase)
            addpath([pwd '/../../src/']);
            addpath([pwd '/../../src/interfaces']);
            testCase.addTeardown(@rmpath,[pwd '/../../src/']);
        end
    end
    methods(Test)
    	function testMouseControllerCreation(testCase)
            testCase.assignOutputsWhen(withExactInputs(testCase.engineMock.behavior.getWindowSize), [0, 0, 1920, 1080])
    		controller = testCase.factory.createController('Mouse', testCase.engineMock.stub);
    		testCase.verifyEqual(class(controller),'MouseController');
    	end

    	function testBCIControllerCreation(testCase)
    		controller = testCase.factory.createController('BCI');
    		testCase.verifyEqual(class(controller),'BCIController');
    	end

    	function testValidController(testCase)
    		testCase.verifyEqual(testCase.factory.isValidController('Mouse'), true);
    		testCase.verifyEqual(testCase.factory.isValidController('LQR'), true);
    		testCase.verifyEqual(testCase.factory.isValidController('BCI'), true);
    		testCase.verifyEqual(testCase.factory.isValidController('Keyboard'), true);
    		testCase.verifyEqual(testCase.factory.isValidController('None'), true);
    		testCase.verifyEqual(testCase.factory.isValidController('Hand'), false);
    	end
	end
end