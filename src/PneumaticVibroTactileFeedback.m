classdef PneumaticVibroTactileFeedback < Feedback & handle
	properties 
		arduinoDevice
	end 

	methods 
		function obj = PneumaticVibroTactileFeedback(system)
			obj@Feedback(system);
			obj.arduinoDevice = serial('/dev/ttyACM0', 'BaudRate', 115200);
		end

		function init(obj)
			disp('Opening channel to device')
			fopen(obj.arduinoDevice);
			disp('Channel opened')
			pause(4);
			cmd = ['P0;-1;10;50;'];
			fprintf(obj.arduinoDevice, cmd);
			flushinput(obj.arduinoDevice);
		end

		function update(obj, dt)
			normalizedState = floor(obj.system.state / obj.system.boundary * 128) + 128
			obj.sendStateToDevice(normalizedState);
		end

		function answer = sendStateToDevice(obj, data)
			answer = false;
			cmd = ['P0;' num2str(data) ';10;50;\n\r'];
			fprintf(obj.arduinoDevice, cmd);
			flushinput(obj.arduinoDevice);
		end

		function endTrial(obj)
			pause(0.1);
			disp('End Trial for PneumaticVibroTactileFeedback');
			cmd = ['P0;-1;10;50;'];
			disp(cmd);
			fprintf(obj.arduinoDevice, cmd);
			flushinput(obj.arduinoDevice);
		end

		function destroy(obj)
			fclose(obj.arduinoDevice);
		end
	end 
end 

