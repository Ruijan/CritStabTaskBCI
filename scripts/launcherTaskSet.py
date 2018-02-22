from appJar import gui
from screeninfo import get_monitors



global app 

def chooseTaskSet(button):
	global app
	if button == "Validate":
		if app.getRadioButton("taskset") == "Critical Stability Task":
			print("mi_cst")
		elif app.getRadioButton("taskset") == "Classic":
			print("mi_hand")
		
	elif button == "Cancel":
		print(str(-1))
	app.stop()

# app.go
app=gui()
padding = 10;
app.setGuiPadding(padding, padding)
app.addRadioButton("taskset", "Critical Stability Task")
app.addRadioButton("taskset", "Classic")
app.addButtons(["Validate", "Cancel"], chooseTaskSet)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)

app.go()
