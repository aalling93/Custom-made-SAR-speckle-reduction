# Speckle reduction of SAR images
Speckle noise inherent in SAR images weakens the meaningful applications of the SAR.
The reduction of the speckle noise is implemented, leading to actual filtering algorithms, based
on the early propositions for speckle filtering. To evaluate the performance of the different
algorithms, several parameters are introduced. All parameters are based on statistical
theory and should be well known within the field. The only exception is the EQP developed by the author to quantify the quality of the edges after a speckle filtering(using an edge detection). 

In addition to the parameters, the analysis builds on the visual interpretation of the SAR images. Conclusively, the
Lee-filter turns out to be superior to the others in terms of speckle reduction and edge
preservation, having only a slight disadvantage in dealing with close targets.

Here, filters useful for **all** types of SAR images are devloped. The fitlers are not assuming that the SAR images are e.g. Sentinel-1. The filters themselves calculate all the neccesary statistics etc. to fully function. 


# MATLAB-Speckle-reduction
Severeal different speckle filters are implemented using Matlab to reduce the noise for different types of applications.
The filters are **not** implemented using Matlab inherent functions (like e.g. its kernel function), and can therefore be directly translated to other languages like Python.

## Implementations:
The following filters have been developed:

-Mean filter.  

-Frost filter. 

-Modified frost filter(added thresholds). 

-Lee filter(Using Masks, ENL ect). 

Note these fitlers are developed without the use of loops in Matlab.


Furhter, a simple sobel edge detection algorithm is implemented ledning to and edge quality paramter.

## Description:

SAR images have a phase and amplitude. Below, a Sentinel-1 SAR VV GRD IW image aquired over Denmark is displyed. 6 Different regions are highlighted.


![Alt text](images/SAR_image_region_lolland.PNG?raw=true "Title")


Due to the inherent speckle in SAR images, speckle reductions must often times be computed. Speckle reduciton can (in general) only be performed on homogenous regions, such as e.g. region 1, region 2 or region 3. If edges occur in images, adaptive speckle reduction must be perfomed as to perserve the edges. Below, a speckle filtering has been done on region 5 (two fields). To the left, we see the origial image being "granular" - this is speckle. We then then see the different filters implemented (the implementation are shown in frost.m etc.). The box filter performs poorly at the edges.


![Alt text](images/region1_test.PNG?raw=true "Title")

Visually, the Lee filter outperforms the others. Below, we can more clearly see how the Lee filter outperform the other fitlers, both with spckle filtering and with edge filtering. It is here clear to see the edge is sharper for the Lee filter, while the homogenous region is speckle filtered.


![Alt text](images/edge_detection.PNG?raw=true "Title")

### Inhomogeneous areas

Below, a speckle filtering and edge detection has been performed on an inhomogenuous region (region 6, a large city), with different theresholds. For information on the thresholds, see the report below. 

![Alt text](images/city_speckle.PNG?raw=true "Title")

It is clear to see that the speckle filtering performs poorly on inhomogenous regions. In fact, this is due to the so-called "Equivalent Number of Looks" (ENL). For the Sentinel-1 IW GRP Images (used here), the images have been averaged on average 4.4 times. This statistics is in fact computable from the different regions for both polarisations, as shown below. Here, we see that region 1,2 and 3(homogeneous) have statistics comparable to the true ENL. The inhomogenuous does not.

![Alt text](images/ENL_test_region.PNG?raw=true "Title")




## Report with code

For motivation or information of the filters, see:  
https://drive.google.com/file/d/1UXcGZB0k54sjeEiX6oCoyUhCtHtZ0CMQ/view?usp=sharing
