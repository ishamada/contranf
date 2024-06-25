# contranf nextflow pipeline

CONTRA-NF is a nextflow pipeline to run CONTRA tool for copy number variation (CNV) detection for targeted resequencing data such as those from whole-exome capture data. CONTRA calls copy number gains and losses for each target region with key strategies include the use of base-level log-ratios to remove GC-content bias, correction for an imbalanced library size effect on log-ratios, and the estimation of log-ratio variations via binning and interpolation. It takes standard alignment formats (BAM/SAM) and output in variant call format (VCF 4.0) for easy integration with other next generation sequencing analysis package.

Required paramters :

--target
--sample
--control
--reference
