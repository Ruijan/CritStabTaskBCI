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

        function update(obj, outcome)
            update@TaskRunner(obj, outcome);
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
            if(obj.loop.connect() == false)
                error('ConnectedTaskRunner:Connection', 'Cannot connect to CNBI Loop.')
            end 
            if(obj.tobiIdSender.attach('/bus') == false)
                error('ConnectedTaskRunner:TIDConnection', 'Cannot connect to attach TobiID to CNBI Loop.')
            end
            obj.checkIfConnected();
            % Send Task Start event at the beginning of the very beginning of the task
            obj.tobiIdSender.sendEvent(1);
        end

		function switchTrial(obj, dt)
            obj.checkIfConnected();
            obj.currentTrial    = obj.currentTrial + 1;
            % Send Start event at the beginning of the trial
            obj.tobiIdSender.sendEvent(781);
        end

        function switchRun(obj, dt)
            obj.currentRun      = obj.currentRun + 1;
            obj.currentTrial    = 1;
        end

        function shouldSwitch = shouldSwitchRun(obj)
            shouldSwitch = obj.currentTrial > obj.trialsPerRun;
        end

        function done = isDone(obj)
        	done = obj.currentRun > obj.runs;
        end

        function checkIfConnected(obj)
            if(obj.loop.isConnected() == false)
                error('ConnectedTaskRunner:Connection', 'Lost connection with CNBI Loop.')
            end 
            if(obj.tobiIdSender.isAttached() == false)
                error('ConnectedTaskRunner:TIDConnection', 'TobiIDSet is not attached to the loop anymore.')
            end
        end
	end
end