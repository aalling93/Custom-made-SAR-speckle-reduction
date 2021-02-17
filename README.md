# Speckle reduction of SAR images
Speckle is the inherent noise-like phenomenon present in Synthetic Aperature Radar images. Here, filters useful for **all** types of SAR images are devloped. The fitlers are not assuming that the SAR images are e.g. Sentinel-1. The filters themselves calculate all the neccesary statistics etc. to fully function. 


# MATLAB-Speckle-reduction
Severeal different speckle filters are implemented using Matlab to reduce the noise for different types of applications.
The filters are **not** implemented using e.g. Matlab inherent functions (like e.g. its kernel function), and can therefore be directly translated to other languages like Python.

## Types in filters
The following filters have been developed:

-Mean filter.  

-Frost filter. 

-Modified frost filter(added thresholds). 

-Lee filter(Using Masks, ENL ect). 

Note these fitlers are developed without the use of loops in Matlab.


## Examples:



## Report with code

For motivation or information of the filters, see:  
https://drive.google.com/file/d/1UXcGZB0k54sjeEiX6oCoyUhCtHtZ0CMQ/view?usp=sharing
