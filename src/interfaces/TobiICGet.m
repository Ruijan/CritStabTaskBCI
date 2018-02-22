classdef TobiICGet < handle & TobiIC
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function obj = TobiICGet(loop)
            obj@TobiIC(loop);
            [obj.tobiIC] = tic_newgetonly();
        end

        function [hasmessage] = getMessage(obj)
            [hasmessage] = tic_getmessage(obj.tobiIC, obj.serializer);
        end

        function [hasmessage] = waitMessage(obj)
            [hasmessage] = tic_waitmessage(obj.tobiIC, obj.serializer);
        end

        function value = getProbability(obj)
            value = icmessage_getvalue(obj.iCMessage, 'mi', '0')
        end
    end
end

