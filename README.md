# contranf nextflow pipeline

CONTRA-NF is a nextflow pipeline to run CONTRA tool for copy number variation (CNV) detection for targeted resequencing data such as those from whole-exome capture data. CONTRA calls copy number gains and losses for each target region with key strategies include the use of base-level log-ratios to remove GC-content bias, correction for an imbalanced library size effect on log-ratios, and the estimation of log-ratio variations via binning and interpolation. It takes standard alignment formats (BAM/SAM) and output in variant call format (VCF 4.0) for easy integration with other next generation sequencing analysis package.


## Prerequisites:

Before you run CONTRA Nextflow pipeline, you need to install Java,Docker and Nextflow. 

### Install Java

First you will need to ensure that you have at least version 8 of java installed. You can check which version you have by typing the following on your command line:

`java -version`

If you don’t have java installed or else need to update the version, installation instructions can be found here: https://www.java.com/en/download/help/linux_x64_install.html.

### Install Nextflow

If you have the correct version of java installed, you can use the following command to download and install Nextflow on your computer:

`curl -fsSL get.nextflow.io | bash`

Now that you have installed Nextflow, it’s good practice to add it to your PATH so you can call it from anywhere on your system:

`mv nextflow ~/bin/`

### Install Docker

You need to install Docker, depends on your operation system, check the following link:

https://docs.docker.com/engine/install/




## Usage:

Now, you can run the pipeline using:

`sudo nextflow run ishamada/contranf -r main \`

`--target /yourpath/test-data/0247401_D_BED_20090724_hg19_MERGED.bed \`

`--sample /yourpath/contra-test-data/P0667T_GATKrealigned_duplicates_marked.bam \`

`--control /yourpath/contra-test-data/P0667N_GATKrealigned_duplicates_marked.bam \`

`--reference /yourpath/contra-test-data/human_g1k_v37.fasta \`

`--output_dir results`

## Required parameters:

### --target
### --sample
### --control
### --reference
### --output_dir


## --target

Target region definition file [BED format]

## --sample

Alignment file for the test sample [BAM/SAM]

## --control 

Alignment file for the control sample [BAM/SAM/BED* – baseline file]

*bed option has to be supplied for control with baseline file.

## --reference

Reference genome [FASTA]

## --output_dir

the folder name (and its path) to store the output of the analysis (this new folder will be created – error message occur if the folder exists)
