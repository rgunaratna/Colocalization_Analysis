/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

processFolder(input);

setBatchMode(true);
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	
	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix))
			imgnum = i+1;
			processFile(imgnum, input, output, list[i]);
	}
}

function processFile(imgnum, input, output, file) {
	path = input + File.separator + file;
	//print(imgnum, "_Processing: " + path);
	open(path);
	//fileOI = File.getName(path);
	//print(file);
	//filename = getTitle();
	//selectWindow(filename);
	Stack.getDimensions(width, height, channels, slices, frames);
	print(channels, width, height, slices, frames);
	print(bitDepth()); 
	bits = bitDepth();

	// Check if it's a multi channel image
	if (channels > 1 || bits == 24) {
		run("Split Channels");
		selectWindow(file + " (green)");
		close();
		//print(file + " (blue)");
		run("EzColocalization ", "reporter_1_(ch.1)=[" + file + " (blue)]" + " reporter_2_(ch.2)=[" + file + " (red)]" + " cell_identification_input=[" + file + " (blue)]" + " alignthold1=default alignthold2=default alignthold4=default area=2500-Infinity dosp hmscale=cell hmcolor1=blue hmcolor2=magenta tos metricthold1=costes' allft-c1-1=10 allft-c2-1=10 pcc metricthold2=costes' allft-c1-2=10 allft-c2-2=10 srcc metricthold3=costes' allft-c1-3=10 allft-c2-3=10 icq metricthold4=costes' allft-c1-4=10 allft-c2-4=10 mcc metricthold5=costes' allft-c1-5=10 allft-c2-5=10 summary histogram(s) mask(s) roi(s)");
		print("Saving to: " + output);

		// save all the generated images as tif in the output_dir
		ch_nbr = nImages; 
		for ( c = 1 ; c <= ch_nbr ; c++){
			selectImage(c);
			currentImage_name = getTitle();
			saveAs("tiff", output + File.separator + currentImage_name);
		}
		close("*");
	
		selectWindow("Log");
		saveAs("Text", output + File.separator + file + "_log.txt");
		close("Log");
	
		selectWindow("Metric(s) of Aligned " + file + " (blue)");
		saveAs("Results", output + File.separator + file + "Result_Table.csv");
		close(file + "Result_Table.csv");
	} else close(file);
}

setBatchMode(false);