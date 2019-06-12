##########################################################################################
#
# This function implements the mean kinetic temperature formula for unequally spaced data, correcting for duplicates.
#
# Reference:  C. Tong & A. Lock, 2015:  A computational procedure for mean kinetic temperature using unequally spaced data.  
# Joint Statistical Meetings, Biopharmaceutical Section, 2065-2070.
# https://www.academia.edu/19390751/A_computational_procedure_for_mean_kinetic_temperature_using_unequally_spaced_data
#
# Note:  one of the inputs to the function is a vector of time points.  It must be formatted as a chron object (use the chron R package).
#
# 12 June 2019
#
##########################################################################################
