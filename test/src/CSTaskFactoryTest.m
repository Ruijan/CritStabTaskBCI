classdef CSTaskFactoryTest < matlab.mock.TestCase & handle
	properties
		factory
	end
	methods(TestMethodSetup)
        function createCSTaskFactory(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.factory = CSTaskFactory();
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
    	function testGraphicCSTaskCreation(testCase)
            import matlab.unittest.constraints.IsAnything;
    		task = testCase.factory.createCSTask('Graphic', ...
                IsAnything, IsAnything, IsAnything, IsAnything, IsAnything, IsAnything);
    		testCase.verifyEqual(class(task),'GraphicalCSTask');
    	end

    	function testHiddenCSTaskCreation(testCase)
            import matlab.unittest.constraints.IsAnything;
            task = testCase.factory.createCSTask('None', ...
                IsAnything, IsAnything, IsAnything, IsAnything, IsAnything);
    		testCase.verifyEqual(class(task),'CSTask');
    	end

    	function testValidCSTask(testCase)
    		testCase.verifyEqual(testCase.factory.isValidCSTask('Graphic'), true);
    		testCase.verifyEqual(testCase.factory.isValidCSTask('None'), true);
    	end
	end
end