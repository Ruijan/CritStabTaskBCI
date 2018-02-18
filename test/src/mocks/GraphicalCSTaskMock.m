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
                    'addlistener',...
                    'delete',...
                    'destroy',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'init',...
                    'initParameters',...
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
                    'saveSuccess',...
                    'shouldSwitchRun',...
                    'start',...
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
                    'controller',...
                    'unstableSystem',...
                    'controllerITR',...
                    'runs',...
                    'trialsPerRun',...
                    'currentTrial',...
                    'currentRun',...
                    'updateRate',...
                    'maxTimePerTrial',...
                    'currentTime',...
                    'results'});
        end
    end
end