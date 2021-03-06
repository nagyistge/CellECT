# Author: Diana Delibaltov
# Vision Research Lab, University of California Santa Barbara

# Imports
import pdb

"Bounding box class. Used especially for segments."

class BoundingBox(object):

	"Bounding box class. Used especially for segments."

	def __init__(self,xmin,xmax, ymin, ymax, zmin, zmax):

		self.xmin = xmin
		self.ymin = ymin
		self.zmin = zmin
		self.xmax = xmax
		self.ymax = ymax
		self.zmax = zmax

	def extend_by(self, N, max_values):

		"Enlarge the bounding box so that it is not a very tight fit."

		self.xmin = max ( [self.xmin - N, 0])
		self.xmax = min ( [self.xmax + 5, max_values[0]-1])
		self.ymin = max ( [self.ymin - N, 0])
		self.ymax = min ( [self.ymax + N, max_values[1]-1])
		self.zmin = max ( [self.zmin - N, 0])
		self.zmax = min ( [self.zmax + N, max_values[2]-1])

