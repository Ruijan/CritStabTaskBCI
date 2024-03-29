classdef SystemFactoryMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = SystemFactoryMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'SystemFactory',...
                    'addlistener',...
                    'createSystem',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'isValidEngine',...
                    'isValidSystem',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify'},...
                'AddedProperties',{});
        end
    end
end