classdef MouseMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = MouseMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'Mouse',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'getMousePosition',...
                    'gt',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'setMousePosition'},...
                'AddedProperties',{});
        end
    end
end