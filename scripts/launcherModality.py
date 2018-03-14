from appJar import gui
from screeninfo import get_monitors



global app 

def chooseModality(button):
	global app
	if button == "Validate":
		if app.getRadioButton("modality") == "Offline":
			print("offline")
		elif app.getRadioButton("modality") == "Online":
			print("online")
		elif app.getRadioButton("modality") == "Training":
			print("training")
		elif app.getRadioButton("modality") == "TrainingVibro":
			print("trainingVibro")
		elif app.getRadioButton("modality") == "TrainingVisualVibro":
			print("trainingVisualVibro")
	elif button == "Cancel":
		print(str(-1))
	app.stop()

# app.go
app=gui()
padding = 10;
app.setGuiPadding(padding, padding)
app.addRadioButton("modality", "Training")
app.addRadioButton("modality", "TrainingVibro")
app.addRadioButton("modality", "TrainingVisualVibro")
app.addRadioButton("modality", "Offline")
app.addRadioButton("modality", "Online")
app.addButtons(["Validate", "Cancel"], chooseModality)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)

app.go()