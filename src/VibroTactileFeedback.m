classdef VibroTactileFeedback < Feedback & handle
	properties 
		arduinoDevice
	end 

	methods 
		function obj = VibroTactileFeedback(system)
			obj@Feedback(system);
			
			obj.arduinoDevice = serial('/dev/ttyUSB0', 'BaudRate', 9600);
		end

		function init(obj)
			fopen(obj.arduinoDevice);
		end

		function update(obj, dt)
			normalizedState = floor(obj.system.state / obj.system.boundary * 128) + 128
			fprintf(obj.arduinoDevice,'%u\n', normalizedState, 'sync');
			% response = fscanf(obj.arduinoDevice);
			% if abs(response - obj.system.state / obj.system.boundary) > 0.001
   %              warning(['arduino received a different command than what was sent: '...
   %               response ' expected ' num2str(obj.system.state / obj.system.boundary)])
   %          end
		end

		function endTrial(obj)

		end

		function destroy(obj)
			fclose(obj.arduinoDevice);
			delete obj.arduinoDevice;
		end
	end 
end 