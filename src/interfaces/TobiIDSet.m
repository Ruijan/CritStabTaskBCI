classdef TobiIDSet < handle & TobiID
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function obj = TobiIDSet(loop)
            obj@TobiID(loop);
            [obj.tobiID] = tid_new_setonly();
        end

        function [hasmessage] = sendEvent(obj, event)
            idmessage_setevent(obj.iDMessage, event);
            idmessage_dumpmessage(obj.iDMessage);
        end

    end
end
