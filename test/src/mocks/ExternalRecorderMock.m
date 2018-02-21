classdef ExternalRecorderMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = ExternalRecorderMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'ExternalRecorder',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify'},...
                'AddedProperties',{...
                    'data',...
                    'timestamp'});
        end
    end
end