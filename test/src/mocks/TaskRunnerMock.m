classdef TaskRunnerMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = TaskRunnerMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'TaskRunner',...
                    'addlistener',...
                    'delete',...
                    'endTrial',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'init',...
                    'isDone',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'shouldSwitchRun',...
                    'startBaseline',...
                    'startBreak',...
                    'startTrial',...
                    'switchRun',...
                    'switchTrial'},...
                'AddedProperties',{...
                    'runs',...
                    'trialsPerRun',...
                    'currentTrial',...
                    'currentRun',...
                    'results'});
        end
    end
end