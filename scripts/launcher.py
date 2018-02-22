from appJar import gui
import getpass
import os
from shutil import copyfile
import xml.etree.ElementTree as ET
import datetime
from screeninfo import get_monitors
import json
global app 
global dataPath

def whichSubject(button):
	if button == "Exit":
		print(str(-1))
		exit()
	else:
		app.showSubWindow(button)
		app.hide()
def validateSubject(button):
	global app
	if button == "Validate":
		subject = app.getEntry("Subject")
		age = app.getEntry("Age")
		createPath(subject)
		xml = createXML(subject,age)
		app.stop()
		print(xml)
	elif button == "Cancel":
		app.setEntry("Subject","")
		app.hideSubWindow("New Subject")
		app.show()

def chooseSubject(button):
	global app
	if button == "Choose":
		user = getpass.getuser()
		subject = app.getRadioButton("subjects")
		subjectPath = dataPath + "/" + subject
		createPath(subject)
		xmlFile = subjectPath + "/mi_cst_prot.xml" 
		print(xmlFile)
		app.stop()
	elif button == "Back":
		app.hideSubWindow("Existing Subject")
		app.show()

def createPath(subject="dev"):
	user = getpass.getuser()
	subjectPath = dataPath + "/" + subject
	tempPath = subjectPath + "/trials"
	if not os.path.isdir(dataPath):
		os.makedirs(dataPath)
	if not os.path.isdir(subjectPath):
		os.makedirs(subjectPath)
	if not os.path.isdir(tempPath):
		os.makedirs(tempPath)

def createXML(subject,age):
	user = getpass.getuser()
	subjectPath = dataPath + "/" + subject
	xmlFile = subjectPath + "/mi_cst_prot.xml" 
	copyfile("/home/cnbi/.cnbitk/cnbimi/xml/mi_cst_prot.xml", xmlFile)
	now = datetime.datetime.now()
	tree = ET.parse(xmlFile)
	root = tree.getroot()
	root.find('subject').find('id').text = subject
	root.find('subject').find('age').text = age
	root.find('recording').find('date').text = str(now.day)+str(now.month)+str(now.year)
	tree.write(xmlFile)
	return xmlFile

	

user = getpass.getuser()
dataPath = "/home/" + user + "/data/BCICourse"
if not os.path.isdir(dataPath):
	os.makedirs(dataPath)
onlydir = [f for f in os.listdir(dataPath) if os.path.isdir(os.path.join(dataPath, f))]
# app.go
app=gui()
padding = 10;

# this is a pop-up
app.startSubWindow("New Subject")
app.setGuiPadding(padding, padding)
app.addLabelEntry("Subject")
app.getEntry("Subject")
app.addLabelEntry("Age")
app.getEntry("Age")
app.addButtons(["Validate", "Cancel"], validateSubject)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.stopSubWindow()

# this is another pop-up
app.startSubWindow("Existing Subject")
for directory in onlydir:
	app.addRadioButton("subjects", directory)
app.addButtons(["Choose", "Back"], chooseSubject)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.stopSubWindow()

# these go in the main window
app.addButtons(["New Subject", "Existing Subject", "Exit"], whichSubject)
app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)
app.go()
