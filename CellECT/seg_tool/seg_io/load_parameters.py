# Author: Diana Delibaltov
# Vision Research Lab, University of California Santa Barbara

# Imports
import pdb
import re
import sys
from termcolor import colored

# Imports from this project
import CellECT.seg_tool.globals 


def parse_config_file_line(line):
	"""
	Parse a line from the config fine: key = value.
	"""

	if not line.strip():
		return None, None
	
	matches = re.match("(.+)=(.+)", line)


	if matches:
		key = matches.group(1).strip().lower()
		val = matches.group(2).strip()

		if not key in CellECT.seg_tool.globals.default_parameter_dictionary_keys:
			raise IOError("Key '%s' not in parameter list" % key)

		if not val:
			raise IOError("No value assigned for key '%s'" % key)
	else:
		raise IOError("No key=value pattern.")
		return None, None


	if CellECT.seg_tool.globals.DEFAULT_PARAMETER.has_key(key):
		raise IOError("Redefinition of key '%s'" % key)
			
	return key, val


def check_if_file_complete():
	"""
	Check if the config file addressed all the parameters needed.
	"""

	missing_info = ""
	for key in CellECT.seg_tool.globals.default_parameter_dictionary_keys:
		if not CellECT.seg_tool.globals.DEFAULT_PARAMETER.has_key(key):
			missing_info += key + " "

	if len(missing_info):
		raise IOError("Error reading config file: incomplete config file. Minssing info: "+missing_info)



def read_program_parameters(config_file_path):

	"Read parameters from config file."

	try:
		f = open(config_file_path)
	except IOError as err:
		print colored("Could not read config file at:" + config_file_path, 'red')
		sys.exit()


	line = f.readline()
	line_counter = 0

	while (line != ""):
		line_counter += 1

		try:
			key, val = parse_config_file_line(line)
			
		except IOError as err:
			print colored("Error at line #%d: %s \nLine #%d: %s" % (line_counter, err.message, line_counter, line.strip() ), "red")
			sys.exit()
			# TODO: write to log file
		except Exception as err:
			print colored("Error at line #%d: %s \nLine #%d: %s" % (line_counter, err.message, line_counter, line.strip() ), "red")
			sys.exit()
			# TODO: write to log file
			
		if key and val:
			CellECT.seg_tool.globals.DEFAULT_PARAMETER[key] = val
		line = f.readline()

	try:
		check_if_file_complete()
	except IOError as err:
		print colored("Error in the config file: %s" % err.message, "red")		
		sys.exit()
		# TODO: write to log file


	
