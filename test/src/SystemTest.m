%% Test Class Definition
classdef SystemTest < matlab.unittest.TestCase
   
    properties
        sys,
        lambda,
        limit,
        expectedTimeLimit
    end
    
    methods(TestMethodSetup)
        function createSystem(testCase)
            % comment
            testCase.lambda = 1.5;
            testCase.limit = 0.2;
            testCase.expectedTimeLimit = 2;
            testCase.sys =  System();
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
        function testSystemCreation(testCase)
            testCase.verifyEqual(testCase.sys.input,    0);
            testCase.verifyEqual(testCase.sys.state,    0);
            testCase.verifyEqual(testCase.sys.lambda,   0);
            testCase.verifyEqual(testCase.sys.boundary, 0);
            testCase.verifyEqual(testCase.sys.expectedTimeLimit, 2);
            testCase.verifyEmpty(testCase.sys.stateMemory);
        end
        function testSystemInit(testCase)
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            testCase.verifyEqual(testCase.sys.lambda,   testCase.lambda);
            testCase.verifyEqual(testCase.sys.boundary, testCase.limit);
            initialState = testCase.limit / exp(testCase.lambda*2);
            testCase.verifyEqual(testCase.sys.state == initialState ||...
                testCase.sys.state == -initialState, true);
        end

        function testSystemSetInput(testCase)
            newInput = 101;
            minInput = 100;
            maxInput = 200;
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            testCase.sys.setInput(newInput, minInput, maxInput);
            testCase.verifyEqual(testCase.sys.input, ...
                (newInput - (maxInput + minInput) / 2) / ((maxInput - minInput) / 2) * testCase.limit);
        end
        function testSystemUpdate(testCase)
            dt          = 0.01;
            newInput    = 0.1;
            minInput    = 100;
            maxInput    = 200;
            
            correctedInput = (newInput - (maxInput + minInput) / 2) / ((maxInput - minInput) / 2) * testCase.limit;
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            state = testCase.sys.state();
            testCase.sys.setInput(newInput, minInput, maxInput);
            testCase.sys.update(dt);
            testCase.verifyEqual(testCase.sys.state, ...
                exp(testCase.lambda*dt) * state + (exp(testCase.lambda*dt) - 1)*correctedInput);
        end

        function testSystemExploding(testCase)
            dt          = 0.01;
            newInput    = 0.1;
            minInput    = 100;
            maxInput    = 200;
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            testCase.sys.setInput(newInput, minInput, maxInput);
            for step = 1:100
                testCase.sys.update(dt);
            end
            testCase.verifyEqual(testCase.sys.exploded,    true);
        end

        function testSystemMemory(testCase)
            dt          = 0.01;
            newInput    = 0.1;
            iterations  = 100;
            states      = zeros(iterations,1);
            inputs      = zeros(iterations,1);
            minInput    = 100;
            maxInput    = 200;
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            testCase.sys.setInput(newInput, minInput, maxInput);
            for step = 1:iterations
                states(step) = testCase.sys.state;
                inputs(step) = testCase.sys.input;
                testCase.sys.update(dt);
            end
            testCase.verifyEqual(length(testCase.sys.stateMemory), iterations);
            testCase.verifyEqual(length(testCase.sys.inputMemory), iterations);
            testCase.verifyEqual(testCase.sys.stateMemory, states);
            testCase.verifyEqual(testCase.sys.inputMemory, inputs);
        end

        function testSystemReset(testCase)
            newInput    = 0.1;
            dt          = 0.01;
            minInput    = 100;
            maxInput    = 200;
            testCase.sys.init(testCase.lambda, testCase.limit, testCase.expectedTimeLimit);
            testCase.sys.setInput(newInput, minInput, maxInput);
            testCase.sys.update(dt);
            testCase.sys.reset();
            testCase.verifyEqual(length(testCase.sys.inputMemory), 0);
            testCase.verifyEqual(length(testCase.sys.stateMemory), 0);
            testCase.verifyEqual(testCase.sys.input, 0);
            initialState = testCase.limit / exp(testCase.lambda*2);
            testCase.verifyEqual(testCase.sys.state == initialState ||...
                testCase.sys.state == -initialState, true);
            testCase.verifyEqual(testCase.sys.lambda, testCase.lambda);
        end
    end
end