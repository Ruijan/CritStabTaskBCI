classdef TobiICMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = TobiICMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'TobiIC',...
                    'TobiICGet',...
                    'addlistener',...
                    'attach',...
                    'delete',...
                    'detach',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'isAttached',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify'},...
                'AddedProperties',{...
                    'tobiIC',...
                    'loop',...
                    'iCMessage',...
                    'serializer'});
        end
    end
end