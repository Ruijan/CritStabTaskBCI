%% Test Class Definition
classdef SystemTest < matlab.unittest.TestCase
   
    properties
        sys,
        lambda,
        limit
    end
    
    methods(TestMethodSetup)
        function createSystem(testCase)
            % comment
            testCase.lambda = 1.5;
            testCase.limit = 0.2;
            testCase.sys =  System(testCase.lambda, testCase.limit);
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
            testCase.verifyEqual(testCase.sys.lambda,   testCase.lambda);
            testCase.verifyEqual(testCase.sys.boundary, testCase.limit);
            testCase.verifyEmpty(testCase.sys.stateMemory);
        end
        function testSystemSetInput(testCase)
            newInput = 0.01;
            testCase.sys.setInput(newInput);
            testCase.verifyEqual(testCase.sys.input,     newInput);
        end
        function testSystemUpdate(testCase)
            dt          = 0.01;
            newInput    = 0.1;
            state       = (exp(testCase.lambda*dt) - 1)*newInput;
            testCase.sys.setInput(newInput);
            testCase.sys.update(dt);            
            testCase.sys.update(dt);
            testCase.verifyEqual(testCase.sys.state, ...
                exp(testCase.lambda*dt) * state + (exp(testCase.lambda*dt) - 1)*newInput);
        end
        function testSystemExploding(testCase)
            dt          = 0.01;
            newInput    = 0.1;
            testCase.sys.setInput(newInput);
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
            testCase.sys.setInput(newInput);
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
    end
end