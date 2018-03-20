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
            idmessage_setfamilytype(obj.iDMessage, 0);
            obj.serializer = idserializerrapid_new(obj.iDMessage);
        end
        function [attached] = isAttached(obj)
            [attached] = tid_isattached(obj.tobiID);
        end
        function attached = attach(obj, name)
            [attached] = tid_attach(obj.tobiID, name);
        end
        function attached = detach(obj)
            attached = obj.isAttached()
            if attached
                [attached] = tid_detach(obj.tobiID);
            end
        end
        function tID = destroy(obj)
            [obj.tobiID]    = tid_delete(obj.tobiID);
            tID             = obj.tobiID;
            obj.serializer  = idserializerrapid_delete(obj.serializer);
            obj.iDMessage   = idmessage_delete(obj.iDMessage);
        end
    end
end

