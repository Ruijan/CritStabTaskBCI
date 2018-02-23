classdef MouseControllerMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = MouseControllerMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'MouseController',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'initController',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'purge',...
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
                    'engine',...
                    'input',...
                    'inputMemory',...
                    'maxInput',...
                    'minInput'});
        end
    end
end