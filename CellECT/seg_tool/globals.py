# Author: Diana Delibaltov
# Vision Research Lab, University of California Santa Barbara


########## globals:

DEFAULT_PARAMETER = {}

_mean_per_dim = []

_std_per_dim = []

should_load_last_save = False

task_index = 0

path_to_workspace = ""

default_parameter_dictionary_keys = ("volume_mat_path",
   "volume_mat_var",\
   "first_seg_mat_path",\
   "first_seg_mat_var", \
   "nuclei_mat_path",\
   "nuclei_mat_var",\
   "training_vol_mat_path",\
   "training_vol_mat_var",\
   "training_vol_nuclei_mat_path", \
   "training_vol_nuclei_mat_var",\
   "training_positive_seg_mat_path",\
   "training_positive_seg_mat_var", \
   "training_positive_labels_mat_path",\
   "training_positive_labels_mat_var",\
   "training_negative_seg_mat_path",\
   "training_negative_seg_mat_var",\
   "training_negative_labels_mat_path",\
   "training_negative_labels_mat_var", \
   "save_location_prefix",\
   "has_bg", \
   "use_size", \
   "use_border_intensity", \
   "use_border_distance")
