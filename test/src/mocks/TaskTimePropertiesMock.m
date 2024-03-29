classdef TaskTimePropertiesMock 
    properties
        stub,
        behavior
    end
    methods
        function obj = TaskTimePropertiesMock(testCase)
            [obj.stub, obj.behavior] = createMock(testCase,...
                'AddedMethods',{...
                    'TaskTimeProperties',...
                    'addlistener',...
                    'delete',...
                    'eq',...
                    'findobj',...
                    'findprop',...
                    'ge',...
                    'gt',...
                    'isValidDuration',...
                    'isvalid',...
                    'le',...
                    'listener',...
                    'lt',...
                    'ne',...
                    'notify'},...
                'AddedProperties',{...
                    'trialDuration',...
                    'breakDuration',...
                    'baselineDuration',...
                    'switchTrialDuration',...
                    'switchRunDuration',...
                    'updateRate',...
                    'precision'});
        end
    end
end