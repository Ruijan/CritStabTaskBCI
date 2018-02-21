classdef TobiID < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tobiID,
        loop,
        iDMessage,
        serializer
    end
    methods
        function obj = TobiID(nLoop)
            obj.loop = nLoop;
            obj.iDMessage = idmessage_new();
            onj.serializer = idserializerrapid_new(obj.iDMessage);
        end
        function [attached] = isAttached(obj)
            [attached] = tid_isattached(obj.loop);
        end
        function attached = attach(obj, name)
            [attached] = tid_attach(obj.tobiID, name);
        end
        function attached = detach(obj)
            [attached] = tid_detach(obj.loop);
        end
        function tID = delete(obj)
            [obj.tobiID] = tid_delete(obj.tobiID);
            tID = obj.tobiID;
        end
    end
end

