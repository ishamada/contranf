# contranf nextflow pipeline

CONTRA-NF is a nextflow pipeline to run CONTRA tool for copy number variation (CNV) detection for targeted resequencing data such as those from whole-exome capture data. CONTRA calls copy number gains and losses for each target region with key strategies include the use of base-level log-ratios to remove GC-content bias, correction for an imbalanced library size effect on log-ratios, and the estimation of log-ratio variations via binning and interpolation. It takes standard alignment formats (BAM/SAM) and output in variant call format (VCF 4.0) for easy integration with other next generation sequencing analysis package.

### Required parameters:

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
