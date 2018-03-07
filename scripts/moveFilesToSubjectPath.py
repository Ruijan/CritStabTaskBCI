import argparse
import getpass
import sys
import os
import xml.etree.ElementTree as ET
import shutil

parser = argparse.ArgumentParser()
parser.add_argument("--subject",    help="Which subject the data are recorded from", required = True)
parser.add_argument("--session",    help="Which session the data are recorded from", required = True)
args, unknown = parser.parse_known_args()
session = args.session
subject = args.subject
user = getpass.getuser()

path = "/home/" + user + "/data/BCICourse/" + subject + "/trials/" + session + "/"
if not os.path.isdir(path):
    os.makedirs(path)
runNumber = 0;
for (dirpath, dirnames, filenames) in os.walk(path):
    for filename in filenames:
        if "Run_" in filename:
            currentRunNumber = int(filename[4]);
            if currentRunNumber > runNumber:
                runNumber = currentRunNumber
pathToCurrentData = "/home/" + user + "/dev/CritStabTaskBCI/"
files = []
for (dirpath, dirnames, filenames) in os.walk(pathToCurrentData):
    for filename in filenames:
        if ".mat" in filename and ".smr.mat" not in filename and "Run__Trial_.mat" not in filename:
            files.append(filename)
            print(filename)
for filename in files:
    newfilename = filename[0:4] + str(runNumber+1) + filename[5::]
    shutil.move(pathToCurrentData + filename, path + newfilename)