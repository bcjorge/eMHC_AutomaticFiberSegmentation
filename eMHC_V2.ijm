//Version 2.0: 
//This macro does eMHC quantification & saves the results as a CSV Table
//Updates: The user can choose the area to segment
// Done by Beatriz Jorge, March 2023

cleanup();			// clean environment

// Get folder and files
dir = getDirectory("folder 'emhc - I'"); //you have to change this name when aplling to other folders
allfiles = getFileList(dir);


// Iterate over files and process images
for(i = 0; i < lengthOf(allfiles); i++){
	
	this_path = dir + allfiles[i];
	if(endsWith(this_path, "C2.tif")){ // ATTENTION: Change to C1 or C2 depending on the Channel of your signal

		// This file is a TIF and its the signal channel. Process it!
		open(this_path);
		print("opened " + this_path);
		
		//for axiovert images, uncomment this line
		//run("Set Scale...", "distance=2.1 known=1 unit=µm");
		
		run("Duplicate...", "title=DUP.tif"); //duplicate the image to segment
		selectWindow("DUP.tif");
		rename(this_path+"_DUP.tif");
		selectWindow(this_path+"_DUP.tif");
		choosesegment();
		binarize_cells();					// segment emhc positive signal
		binary_to_bands(25);              // get envelope ROIs (Regions of interest) - ATTENTION - here you can choose the minimun size your cells are going to have
		saveAs("Tiff", this_path+"_DUP.tif"); //save the segmentation image
		path_csv = replace(this_path, ".tif", ".csv");
		save_res(path_csv); //save the results table
	
		cleanup(); //clean images, table and rois for next image
	}
}

print("Finished");

//////////// Custom functions below /////////////////



// Close images and clear windows
function cleanup(){
	run("Close All");			// close all images
	run("Clear Results");		// Empty results table
	roiManager("reset");		// Empty manager
}

//segment the area that you want to use for the segmentation
function choosesegment(){
	setTool("freehand");
	waitForUser("Select region of interest in image.\nClick OK when done");
	run("Crop");
}
// Threshold and binarize cells.
function binarize_cells(){
	print("Start Thersholding...");
	run("Top Hat...", "radius=30"); //if you want another value change radius
	setAutoThreshold("MaxEntropy dark"); 
	run("Threshold...");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	print("Thershold Finnished.");
	
}



// Convert binarized image into cell envelope ROIs. Retain cells which have at least 'min_pixels'
function binary_to_bands(min_pixels){
	print("Start Segmentation...");
	run("Set Measurements...", "area mean add redirect=None decimal=3");
	run("Analyze Particles...", "size="+min_pixels+"-Infinity display overlay add"); //add to ROI-Manager by running analyze particles
	print("Segmentation Finnished.");
}


function save_res(path_out) { 
	print("Writing " + path_out);
	saveAs("Results", path_out);
	print("table saved");
	
 
}