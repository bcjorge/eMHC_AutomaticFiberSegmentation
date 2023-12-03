//Version 2.0: 
//This macro slipts the images in two channels, gives them color and saves them as tif
//New: You can get the total of tissue area - Function getTotal
// Done by Beatriz Jorge, March 2023

//process and call folder 

cleanup();			// clean environment

// Get folder and files
dir = getDirectory("folder 'testeigg'"); //you have to change this name when aplling to other folders
allfiles = getFileList(dir);


// Iterate over files and process images
for(i = 0; i < lengthOf(allfiles); i++){
	
	this_path = dir + allfiles[i];
	if(endsWith(this_path, ".czi")){ //this Macro only opens CZI images
		print("A abrir imagem");

		// This file is a TIF. Process it!
		run("Bio-Formats Importer", "open=["+this_path+"] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
		print("opened " + this_path);
		
		//save files - tif images are going for the same path as czi images
		//to alter the path: this_path+"/yourfolder"					
		split_channels(this_path);
		getTotal();
		cleanup();
	}

}
saveAs("ResultsTotal", dir+"ResultsTotal.csv");
run("Clear Results");
print("Finished");

function cleanup(){
	run("Close All");			// close all images
			// Empty results table
	roiManager("reset");		// Empty manager
}

function getTotal(){
	run("Set Measurements...", "area mean display add redirect=None decimal=3");
	setTool("freehand");
	waitForUser("Select region of interest in image.\nClick OK when done");
	run("Measure");
}

// Split and name channels
function split_channels(path_out){
	title = getTitle();
	
	//split channels and rename them
	run("Split Channels");
	
	//Channel 1
	selectWindow("C1-"+title);
	run("Cyan"); //change to Red if the first is the signal
	run("Window/Level...");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", path_out+title+"_C1.tif"); //alter your path
	
	
	//Channel 2
	selectWindow("C2-"+title);
	run("Red"); //change to Cyan if the second is the DAPI
	run("Window/Level...");
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", path_out+title+"_C2.tif"); //alter your path
}


