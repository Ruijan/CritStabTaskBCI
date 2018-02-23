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
pathToCurrentData = "/home/" + user + "/dev/CritStabTaskBCI/"
files = []
for (dirpath, dirnames, filenames) in os.walk(pathToCurrentData):
    for filename in filenames:
        if ".mat" in filename and ".smr.mat" not in filename:
            files.append(filename)
for filename in files:
    shutil.move(pathToCurrentData + filename, path + filename)