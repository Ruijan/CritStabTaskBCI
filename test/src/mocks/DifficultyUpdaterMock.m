classdef DifficultyUpdaterMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = DifficultyUpdaterMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'DifficultyUpdater',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'getNewDifficulty',...
                    'gt',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'update'},...
                'AddedProperties',{});
        end
    end
end