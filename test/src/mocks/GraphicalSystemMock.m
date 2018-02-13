classdef GraphicalSystemMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = GraphicalSystemMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'GraphicalSystem',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'exploded',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'reset',...
                    'setInput',...
                    'update',...
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
                    'gBoundary',...
                    'gState',...
                    'engine',...
                    'input',...
                    'state',...
                    'lambda',...
                    'boundary',...
                    'stateMemory',...
                    'inputMemory'});
        end
    end
end