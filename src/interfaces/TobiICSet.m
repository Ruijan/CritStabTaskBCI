classdef TobiICSet < handle & TobiIC
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    properties
        serializer
    end

    methods
        function obj = TobiICSet(serializer)
            obj@TobiIC();
            obj.serializer = serializer;
            mex_id_ = 'o ClTobiIc* = ticnewsetonly()';
            [obj.tobiIC = cnbiloop(mex_id_);
        end
        function [setmessage] = setMessage(obj, blockidx)
            mex_id_ = 'o bool = ticsetmessage(i ClTobiIc*, i ICSerializerRapid*, i int)';
            [setmessage] = cnbiloop(mex_id_, obj.loop, obj.serializer, blockidx);
        end
    end
end

