# Colocalization Analysis of nuclear β-Catenin

Wnt signling activation results in β-Catenin nuclear localization releaving repression of Wnt target gene expression. Nuclear localization of β-catenin could be measured by identifying fluorescently-tagged β-catenin in DAPI-positive nuclei.

## About 
Customized macro and R scripts performs processing of 24-bit composite images for colocaliazation analysis of nuclear β-Catenin using EzColocalization in Fiji and data processing for visualization using R.

### 1. Fiji macro script 

The script was modified from 'Process folder' macro script. Modifications include; 

  - Check for multi-channel 24-bit composite image before processing an image 
  - Split channels 
  - Run [EzColocalization plugin](https://github.com/DrHanLim/EzColocalization) with the follwoing settings: 


    **Inputs**
      - reporter_1_(ch.1) = blue channel (DAPI) image 
      - reporter_2_(ch.2) = red channel ($\beta$-Catenin signal) image 
      - cell_identification_input = blue channel (DAPI) image 
      - alignthold1 = default 
      - alignthold2 = default 
      - alignthold4 = default 
    

    **Cell Filters** 
      - Pre-watershed filter: area = 2500-Infinity 
    
 
    **Visualization** 
      - heatmap scale = cell 
      - Color map channel 1 = blue 
      - Color map channel 2 = magenta 
      - Cell pixel intensity scatterplots: Yes 
      - Metric: tos
      

    **Analysis** 
      - Metric threshold method = costes'  
      - All ft-c1-1=10 
      - All ft-c2-1=10 
      - Summary: Yes 
      - Histogram(s): Yes 
      - Mask(s): Yes 
      - ROI(s): Yes 


    - Save all images, log file and measurement table generated by EzColocalization plugin 
    

### 2. R script 
 
The script aggregates colocalization measurements and processes data for downstream 
visualization and statistical comparisons using [ggpubr](https://github.com/kassambara/ggpubr) R package.


