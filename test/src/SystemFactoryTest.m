classdef SystemFactoryTest < matlab.mock.TestCase & handle
	properties
		factory
	end
	methods(TestMethodSetup)
        function createSystemFactory(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.factory = SystemFactory();
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
    	function testGraphicSystemCreation(testCase)
    		newSystem = testCase.factory.createSystem('Graphic');
    		testCase.verifyEqual(class(newSystem),'GraphicalSystem');
    	end

    	function testHiddenSystemCreation(testCase)
    		newSystem = testCase.factory.createSystem('None');
    		testCase.verifyEqual(class(newSystem),'System');
    	end

    	function testValidSystem(testCase)
    		testCase.verifyEqual(testCase.factory.isValidSystem('Graphic'), true);
    		testCase.verifyEqual(testCase.factory.isValidSystem('None'), true);
    	end
	end
end