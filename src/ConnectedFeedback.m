classdef ConnectedFeedback < Feedback & handle
	properties 
		loop,
        tobiIdSender,
        lastEventSent,
    	endEventOffset = 32768
	end 
	methods 
		function obj = ConnectedFeedback(loop, tobiIdSender, nSystem)
	        obj@Feedback(nSystem);
			obj.loop = loop;
			obj.tobiIdSender = tobiIdSender;
		end

		function obj = init(obj)
			lastEventSent = 1;
		end

		function update(obj)
			if length(obj.system.stateMemory) > 2
				if obj.system.state >= 0 && obj.system.stateMemory(end) < 0
					obj.tobiIdSender.sendEvent(obj.lastEventSent + endEventOffset);
					obj.tobiIdSender.sendEvent(782);
					obj.lastEventSent = 782;
				elseif obj.system.state < 0 && obj.system.stateMemory(end) >= 0
					obj.tobiIdSender.sendEvent(obj.lastEventSent + endEventOffset);
					obj.tobiIdSender.sendEvent(783);
					obj.lastEventSent = 783;
				end
			else
				if obj.system.state > 0 && length(obj.system.stateMemory) == 1
					obj.tobiIdSender.sendEvent(782);
					obj.lastEventSent = 782;
				elseif obj.system.state < 0 && length(obj.system.stateMemory) == 1
					obj.tobiIdSender.sendEvent(783);
					obj.lastEventSent = 783;
				end
			end
		end

		function checkIfConnected(obj)
	        if(obj.loop.isConnected() == false)
	            obj.tryConnectingToLoop();
	        end 
	        if(obj.tobiIdSender.isAttached() == false)
	            obj.tryConnectingToTobiId();
	        end
	    end

	    function tryConnectingToTobiId(obj)
	        if(obj.tobiIdSender.attach('/bus') == false)
	            error('ConnectedTaskRunner:TIDConnection', 'Cannot connect to attach TobiID to CNBI Loop.')
	        end
	    end

	    function tryConnectingToLoop(obj)
	        % Connect to the CnbiTk loop
	        if(obj.loop.connect() == false)
	            error('ConnectedTaskRunner:Connection', 'Cannot connect to CNBI Loop.')
	        end 
	    end

		function destroy(obj)
	        obj.tobiIdSender.detach();
	        obj.tobiIdSender.delete();
	        obj.loop.disconnect();
	    end

	    function endTrial(obj)
			obj.tobiIdSender.sendEvent(obj.lastEventSent + endEventOffset);
		end
	end
end 