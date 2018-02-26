classdef GraphicalCSTaskMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = GraphicalCSTaskMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'GraphicalCSTask',...
                    'addRecorder',...
                    'addlistener',...
                    'computeITR',...
                    'delete',...
                    'destroy',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'getOutcome',...
                    'gt',...
                    'init',...
                    'isDone',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'pauseTask',...
                    'purge',...
                    'runTrial',...
                    'save',...
                    'start',...
                    'startFixationPeriod',...
                    'switchRun',...
                    'switchTrial',...
                    'update',...
                    'updateTask',...
                    'accumarray',...
                    'cell2struct',...
                    'cellismemberlegacy',...
                    'ctranspose',...
                    'display',...
                    'intersect',...
                    'ismember',...
                    'issorted',...
                    'issortedrows',...
                    'maxk',...
                    'mink',...
                    'permute',...
                    'reshape',...
                    'setdiff',...
                    'setxor',...
                    'sort',...
                    'strcat',...
                    'strmatch',...
                    'transpose',...
                    'union',...
                    'unique'},...
                'AddedProperties',{...
                    'engine',...
                    'trialBreakTime',...
                    'fixationTime',...
                    'runBreakTime',...
                    'controller',...
                    'unstableSystem',...
                    'difficultyUpdater',...
                    'taskRunner',...
                    'recorders',...
                    'controllerITR',...
                    'ITRMemory',...
                    'updateRate',...
                    'maxTimePerTrial',...
                    'currentTime',...
                    'userDone'});
        end
    end
end