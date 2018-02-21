classdef ControllerEvaluatorTest < matlab.mock.TestCase & handle

	properties
		evaluator
	end
	methods(TestMethodSetup)
        function createEvaluator(testCase)
            import matlab.unittest.TestCase
            import matlab.mock.constraints.WasCalled;
            import matlab.unittest.constraints.IsAnything;
            testCase.evaluator = ControllerEvaluator();
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
		function testEvaluatorCreation(testCase)
        end

        function testEvaluatorEvaluate(testCase)
        	testCase.evaluator.evaluate(rand(100,1) - 0.5, rand(100,1) - 0.5);
        end

        function testComputePerfectChannelCapacity(testCase)
        	channelCapacity = testCase.evaluator.computeChannelCapacity(0,0);
        	testCase.verifyEqual(channelCapacity, 1);
        end

        function testComputeWorstChannelCapacity(testCase)
        	channelCapacity = testCase.evaluator.computeChannelCapacity(0.5, 0.5);
        	testCase.verifyEqual(channelCapacity, 0);
        end

        function testComputePerfectChannelCapacity2(testCase)
        	channelCapacity = testCase.evaluator.computeChannelCapacity(1, 1);
        	testCase.verifyEqual(channelCapacity, 1);
        end

        function testComputePerfectChannelCapacity3(testCase)
        	channelCapacity = testCase.evaluator.computeChannelCapacity(NaN, 0);
        	testCase.verifyEqual(channelCapacity, 1);
        end
	end
end