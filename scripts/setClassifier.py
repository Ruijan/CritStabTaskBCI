import argparse
from appJar import gui
from screeninfo import get_monitors
import getpass
import sys
from os import walk
import xml.etree.ElementTree as ET


global app 
global data
global dataDouble
global dataSingle
global fileName


parser = argparse.ArgumentParser()
parser.add_argument("--modality", help="For which modality you are setting classifier path", required = True)
parser.add_argument("--subject", 	help="For which subject you are setting classifier path", required = True)

args, unknown = parser.parse_known_args()
modality = args.modality
subject = args.subject

def chooseValues(button):
 	global app
 	if button == "Validate":
 		user = getpass.getuser()
 		path = "/home/" + user + "/data/BCICourse/" + subject + "/"
 		xmlFile = path + "/mi_cst_prot.xml"
 		tree = ET.parse(xmlFile)
 		root = tree.getroot()
 		root.find('classifier').find('kmi2').find('filename').text = app.getRadioButton("classifier")
 		tree.write(xmlFile)
 	elif button == "Cancel":
 		print(str(-1))
 		
 	app.stop()
if modality == "online":

	user = getpass.getuser()
	path = "/home/" + user + "/data/BCICourse/" + subject + "/"
	f = []
	for (dirpath, dirnames, filenames) in walk(path):
	    for filename in filenames:
		    if ".mat" in filename and ".smr.mat" not in filename:
		    	f.append(filename)
	    break

	# # # app.go
	sys.argv = [sys.argv[0]];
	app=gui()
	padding = 10;
	app.setGuiPadding(padding, padding)
	for filename in f:
		app.addRadioButton("classifier", filename)

	app.addButtons(["Validate", "Cancel"], chooseValues)
	app.setLocation(get_monitors()[0].width/2, get_monitors()[0].height/2)

	app.go()
