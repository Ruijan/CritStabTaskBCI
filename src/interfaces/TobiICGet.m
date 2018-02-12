classdef TobiICGet < handle & TobiIC
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function obj = TobiICGet()
            obj@TobiIC();
            [obj.tobiIC] = tic_newgetonly();
        end

        function [hasmessage] = getMessage(obj)
            mex_id_ = 'o bool = ticgetmessage(i ClTobiIc*, i ICSerializerRapid*)';
            [hasmessage] = cnbiloop(mex_id_, obj.tobiIC, obj.serializer);
        end

        function [hasmessage] = waitMessage(obj)
            mex_id_ = 'o bool = ticwaitmessage(i ClTobiIc*, i ICSerializerRapid*)';
            [hasmessage] = cnbiloop(mex_id_, obj.tobiIC, obj.serializer);
        end

        function [message] = getICMessage(obj)
            message = iCMessage;
        end
    end
end

