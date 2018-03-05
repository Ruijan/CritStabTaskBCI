classdef GraphicalEngineMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = GraphicalEngineMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'GraphicalEngine',...
                    'addlistener',...
                    'checkIfKeyPressed',...
                    'closeAllWindows',...
                    'delete',...
                    'drawArc',...
                    'drawFilledCircle',...
                    'drawFilledRect',...
                    'drawText',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'getCenter',...
                    'getMousePosition',...
                    'getWhiteIndex',...
                    'getWindowSize',...
                    'gt',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'openWindow',...
                    'setMousePosition',...
                    'updateScreen'},...
                'AddedProperties',{...
                    'window',...
                    'windowSize',...
                    'setup',...
                    'previousKeyPressed'});
        end
    end
end