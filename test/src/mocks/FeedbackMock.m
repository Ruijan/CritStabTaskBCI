classdef FeedbackMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = FeedbackMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'Feedback',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'init',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify',...
                    'update'},...
                'AddedProperties',{...
                    'system'});
        end
    end
end