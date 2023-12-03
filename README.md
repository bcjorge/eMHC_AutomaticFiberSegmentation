# eMHC_AutomaticFiberSegmentation
This scripts does eMHC quantification and saves the results as a CSV Table.
Done by Eng.Beatriz Jorge, March 2023

Key Features for analysis

- Split the channels and save them separately (Tif & Split Script)
- Find the total cross-sectional area of the muscle (Tif & Split Script)
- Limit the image to the location to be analyzed (eMHC_V2 Script)
- Pre-processing, Signal Threshold & Filtering (eMHC_V2 Script)
- Save results in CSV and duplicate the image(eMHC_V2 Script)

Steps for Tif & Split Script usage:
1. Confirm if your Signal is in Channel 1 or Channel 2 and change the color in the split_channels function.
2. Put all your .czi images in a folder and after run the macro
3. Wait for the splitting part and outline the total area of the tissue
4. In the end you are going to have in the folder:
- 2 images: name_C1 & name_C2
- A .csv file with the Total Area of all the samples
- The original .czi file.

Steps for eMHC_V2 usage:
1. run the Macro
2. In the end you are going to have in the folder:
- An image duplication with all of the segmentations (i.e. Image_DUP)
- A .csv file for each sample with the fibers area
- The original .tif file

