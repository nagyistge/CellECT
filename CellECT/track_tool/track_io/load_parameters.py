# Author: Diana Delibaltov
# Vision Research Lab, University of California Santa Barbara

# Imports
import re
import pdb

# Imports from this project
import CellECT.track_tool.globals


"""
Load parameters from the config file.
Prepare global parameters.
Load defaults, if applicable.
"""


def get_time_stamps_from_input_string(input_string):

	CellECT.track_tool.globals.PARAMETER_DICT["time-stamps"] = [int(number.strip()) for number in input_string.split(" ")]

def read_program_parameters(config_file_path):

	# TODO unit tests for this

	f = open(config_file_path)
	line = f.readline()
	
	while (line != ""):
		matches = re.match("(.*)=(.*)", line)
		if matches:
			key = matches.group(1).strip()
			val = matches.group(2).strip()
			CellECT.track_tool.globals.PARAMETER_DICT[key] = val
		else:
			print "ERROR reading config file"
		line = f.readline()


	get_time_stamps_from_input_string(CellECT.track_tool.globals.PARAMETER_DICT["time-stamps"])

