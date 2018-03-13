classdef VibroTactileFeedback < Feedback & handle
	properties 
		arduinoDevice
		connectedMessage = [1, 0, 1, 255];
		disconnectedMessage = [1, 0, 255, 255];
		dataMessage = [1, 0, 2, 255];
	end 

	methods 
		function obj = VibroTactileFeedback(system)
			obj@Feedback(system);
			
			obj.arduinoDevice = serial('/dev/ttyUSB0', 'BaudRate', 9600);
		end

		function init(obj)
			disp('Opening channel to device')
			fopen(obj.arduinoDevice);
			disp('Channel opened')
			set(obj.arduinoDevice, 'TimeOut', 1);
			set(obj.arduinoDevice,'Terminator','CR');
			
			disp('Connecting to serial')
			obj.connectToArduino();
		end

		function update(obj, dt)
			normalizedState = floor(obj.system.state / obj.system.boundary * 128) + 128
			obj.dataMessage(2) = normalizedState;
			obj.sendDataToDevice(obj.dataMessage, false);
		end

		function answer = sendDataToDevice(obj, data, checkAnswer)
			answer = false;
			for i = 1:length(data)
		        fwrite(obj.arduinoDevice, data(i));
		    end
		    if checkAnswer
				response = fread(obj.arduinoDevice, 4, 'uint8');
			    response = response';
			    if ~isequal(response, data)
			        warning(['Sent ' mat2str(data) ' Arduino got: ' mat2str(response)]);
			    else
			    	answer = true;
			    end
		    end
		end

		function endTrial(obj)

		end

		function connectToArduino(obj)
			notConnected = true;
			pause(3)
			while notConnected
				answer = obj.sendDataToDevice(obj.connectedMessage, true);
			    if answer
			        notConnected = false;
			        disp('Connected');
			    else
			        disp('Connection failed');
			    end
			end
		end

		function destroy(obj)
			connected = true;
			while connected
				answer = obj.sendDataToDevice(obj.disconnectedMessage, true);			   
			    if answer
			        disp('Disconnect');
			        connected = false;
			    else
			        disp('Disconnection failed');
			    end
			end
			fclose(obj.arduinoDevice);
		end
	end 
end 

