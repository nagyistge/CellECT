# Author: Diana Delibaltov
# Vision Research Lab, University of California Santa Barbara

# Imports

import os
import pdb
import xml.etree.ElementTree as ET

# Imports from this project
from CellECT.workspace_management import metadata as md


class WorkSpaceData(object):

	def __init__ (self):

		self.metadata = md.Metadata()
		self.available_segs = []
		self.workspace_location = None


	def set_location(self, filename):

		self.workspace_location = os.path.dirname(filename)
		


	def load_metadata(self, filename):

		self.metadata.load_bq_csv_file(filename)

		self.set_location(filename)


	def get_available_segs(self):

		self.available_segs = set()
		for i in xrange (self.metadata.numt):
			file_name = "%s/segs_all_time_stamps/timestamp_%d_label_map.mat" % (self.workspace_location, i)
   			if os.path.exists(file_name):
				self.available_segs.add(i)


	def load_workspace(self, location):

		tree = ET.parse(location)
		root = tree.getroot()
		metadata_field = root.find("metadata")
		self.metadata.load_from_etree(metadata_field)


	def write_xml(self):
	
		root = ET.Element("CellECT_workspace")

		metadata_field = self.metadata.metadata_etree()
	
		root.append(metadata_field)
	
		tree = ET.ElementTree(root)

		file_name = "%s/workspace_data.cws" % self.workspace_location
		tree.write(file_name)

		



