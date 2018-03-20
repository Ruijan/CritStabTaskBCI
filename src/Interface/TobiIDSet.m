classdef TobiIDSet < handle & TobiID
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    properties
        messages = [],
        timers  = [],
        nextCall = 0
        delay = 0.0625;
    end 
    
    methods
        function obj = TobiIDSet(loop)
            obj@TobiID(loop);
            [obj.tobiID] = tid_new_setonly();
        end

        function [hasmessage] = sendEvent(obj, event)
            obj.messages = [obj.messages event];
            obj.nextCall = obj.nextCall + obj.delay;
            disp(['Event ' num2str(event) ' will be sent in ' num2str(obj.nextCall)]);
            t = timer('StartDelay', obj.nextCall, 'TimerFcn', @(~,~)obj.sendNextMessage());
            obj.timers = [obj.timers t];
            start(t);
        end

        function sendNextMessage(obj)
            idmessage_setevent(obj.iDMessage, obj.messages(1));
            tid_setmessage(obj.tobiID, obj.serializer, -1);
            obj.nextCall = obj.nextCall - obj.delay;
            delete(obj.timers(1))
            disp(['Send event ' num2str(obj.messages(1))]);
            obj.messages(1) = [];
            obj.timers(1) = [];
        end
    end
end

