from appJar import gui
import argparse
import getpass
import os
from screeninfo import get_monitors
import sys

global app 
global dataPath
global subject

parser = argparse.ArgumentParser()
parser.add_argument("--subject", 	help="For which subject you are setting session path", required = True)
args, unknown = parser.parse_known_args()
subject = args.subject

def whichSession(button):
	if button == "Exit":
		print(str(-1))
		exit()
	else:
		app.showSubWindow(button)
		app.hide()
def validateSession(button):
	global app
	if button == "Validate":
		session = app.getEntry("Session")
		createPath(session)
		app.stop()
		print(session)
	elif button == "Cancel":
		app.setEntry("Session","")
		app.hideSubWindow("New Session")
		app.show()

def chooseSession(button):
	global app
	if button == "Choose":
		session = app.getRadioButton("sessions")
		sessionPath = dataPath + "/" + session
		createPath(session)
		print(session)
		app.stop()
	elif button == "Back":
		app.hideSubWindow("Existing Session")
		app.show()

def createPath(session="training"):
	sessionPath = dataPath + "/" + session
	if not os.path.isdir(sessionPath):
		os.makedirs(sessionPath)
	

user = getpass.getuser()
dataPath = "/home/" + user + "/data/BCICourse/" + subject
if not os.path.isdir(dataPath):
	os.makedirs(dataPath)
onlydir = [f for f in os.listdir(dataPath) if os.path.isdir(os.path.join(dataPath, f)) and f != '.' and f != '..' and f != 'trials']
# app.go
sys.argv = [sys.argv[0]];
app=gui()
padding = 10;

# this is a pop-up
app.startSubWindow("New Session")
app.setGuiPadding(padding, padding)
app.addLabelEntry("Session")
app.getEntry("Session")
app.addButtons(["Validate", "Cancel"], validateSession)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.stopSubWindow()

# this is another pop-up
app.startSubWindow("Existing Session")
for directory in onlydir:
	app.addRadioButton("sessions", directory)
app.addButtons(["Choose", "Back"], chooseSession)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.stopSubWindow()

# these go in the main window
app.addButtons(["New Session", "Existing Session", "Exit"], whichSession)
if len(onlydir) == 0:
	app.disableButton("Existing Session")
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.go()
