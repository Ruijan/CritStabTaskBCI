classdef ConnectedTaskRunner < handle & TaskRunner
	properties
		loop,
        tobiIdSender
	end

	methods
		function obj = ConnectedTaskRunner(loop, tobiIdSender, runs, trialsPerRun)
            obj@TaskRunner(runs, trialsPerRun);

			obj.loop = loop;
			obj.tobiIdSender = tobiIdSender;
		end

        function endTrial(obj, outcome)
            endTrial@TaskRunner(obj, outcome);
            obj.checkIfConnected();
            if outcome == 1
                % Send Hit/Success event in case of stable system
                obj.tobiIdSender.sendEvent(897);
            else
                % Send Failure/Miss event in case of unstable system
                obj.tobiIdSender.sendEvent(898);
            end
        end

        function init(obj)
            % Connect to the CnbiTk loop
            obj.tryConnectingToLoop();
            obj.tryConnectingToTobiId();
            obj.checkIfConnected();
            % Send Task Start event at the beginning of the very beginning of the task
            obj.tobiIdSender.sendEvent(1);
        end

        function startBaseline(obj, dt)
            obj.checkIfConnected();
            % Send Cross event at the beginning of the baseline
            obj.tobiIdSender.sendEvent(786);
        end

        function startTrial(obj, dt)
            obj.checkIfConnected();
            % Send Start event at the beginning of the trial
            obj.tobiIdSender.sendEvent(781);
        end

        function shouldSwitch = shouldSwitchRun(obj)
            shouldSwitch = obj.currentTrial > obj.trialsPerRun;
        end

        function done = isDone(obj)
        	done = obj.currentRun > obj.runs;
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
            obj.tobiIdSender.destroy();
            obj.loop.disconnect();
        end
	end
end