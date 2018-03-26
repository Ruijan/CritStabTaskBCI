classdef ConnectedOnlineFeedback < Feedback & handle
	properties 
		loop,
        tobiIdSender,
        lastEventSent,
    	endEventOffset = 32768
	end 
	methods 
		function obj = ConnectedOnlineFeedback(loop, tobiIdSender, nSystem)
	        obj@Feedback(nSystem);
			obj.loop = loop;
			obj.tobiIdSender = tobiIdSender;
		end

		function obj = init(obj)
			obj.lastEventSent = 1;
		end

		function update(obj, dt)
			if length(obj.system.stateMemory) > 2
				if obj.system.state >= 0 && obj.system.stateMemory(end-1) < 0
					%obj.tobiIdSender.sendEvent(781 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(782);
					%obj.tobiIdSender.sendEvent(782 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(781);
					obj.lastEventSent = 782;
				elseif obj.system.state < 0 && obj.system.stateMemory(end-1) >= 0
					%obj.tobiIdSender.sendEvent(781 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(783);
					%obj.tobiIdSender.sendEvent(783 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(781);
					obj.lastEventSent = 783;
				end
			else
				if obj.system.state > 0 && length(obj.system.stateMemory) == 1
					%obj.tobiIdSender.sendEvent(782);
					%obj.tobiIdSender.sendEvent(782 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(781);
					obj.lastEventSent = 782;
				elseif obj.system.state < 0 && length(obj.system.stateMemory) == 1
					%obj.tobiIdSender.sendEvent(783);
					%obj.tobiIdSender.sendEvent(783 + obj.endEventOffset);
					%obj.tobiIdSender.sendEvent(781);
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

	    end

	    function endTrial(obj)
			obj.tobiIdSender.sendEvent(781 + obj.endEventOffset);
		end
	end
end 