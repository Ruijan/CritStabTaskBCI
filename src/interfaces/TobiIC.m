classdef TobiIC < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tobiIC,
        loop,
        iCMessage,
        serializer
    end
    methods
        function obj = TobiIC(nLoop)
            obj.loop = nLoop;
            obj.iCMessage = icmessage_new();
            onj.serializer = icserializerrapid_new(obj.iCMessage);
        end
        function [attached] = isAttached(obj)
            [attached] = tic_isattached(obj.loop);
        end
        function attached = attach(obj, name)
            [attached] = tic_attach(obj.tobiIC, name);
        end
        function attached = detach(obj)
            [attached] = tic_detach(obj.loop);
        end
        function tIC = delete(obj)
            [obj.tobiIC] = tic_delete(obj.tobiIC);
            tIC = obj.tobiIC;
        end
    end
end

