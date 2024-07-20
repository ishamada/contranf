#!/usr/bin/env nextflow
// Dev version 2.3 # Author:islam.salah@gmail.com

// pipeline input parameters
params.target = "/home/islam/contra-test-data/0247401_D_BED_20090724_hg19_MERGED.bed"
params.sample = "/home/islam/contra-test-data/P0667T_GATKrealigned_duplicates_marked.bam"
params.control = "/home/islam/contra-test-data/P0667N_GATKrealigned_duplicates_marked.bam"
params.reference = "/home/islam/contra-test-data/human_g1k_v37.fasta"
params.output_dir = "results"

params.sheet = ""

///// production //////////////
////////////////////// Required
// params.target = ""
// # Target region definition file [BED format]
// params.test = ""
// # Alignment file for the test sample [BAM/SAM]
// params.control = ""
// # Alignment file for the control sample [BAM/SAM/BED* – baseline file]
// *--bed option has to be supplied for control with baseline file.
// params.fasta = ""
//	# Reference genome [FASTA] (NOT REQUIRED since v2.0.8)
// params.outFolder = ""
// # the folder name (and its path) to store the output of the analysis (this new folder will be created – error message occur if the folder exists)

///////////////////// Optional
params.numBin = "20"
//	# Numbers of bins to group the regions. User can specify multiple experiments with different numbers of bins (comma separated). [Default: 20]
params.minReadDepth = "10"
//	# The threshold for minimum read depth for each bases (see Step 2 in CONTRA workflow) [Default: 10]
params.minNBases = "10"
//	# The threshold for minimum number of bases for each target regions (see Step 2 in CONTRA workflow) [Default: 10]
params.sam = "False"
//	# If the specified test and control samples are in SAM format. [Default: False] (It will always take BAM samples as default)
// params.bed = "False"
//	# If specified, control will be a baseline file in BED format. [Default: False]
//	*Please refer to the Baseline Script section for instruction how to create baseline files from set of BAMfiles. A set of baseline files from different platform have also been provided in the CONTRA download page.
params.pval = ".05"
//	# The p-value threshold for filtering. Based on Adjusted P-Values. Only regions that pass this threshold will be included in the VCF file. [Default: 0.05]
params.sampleName = ""
//	# The name to be appended to the front of the default output name. By default, there will be nothing appended.
params.nomultimapped = "FALSE"
//	# The option to remove multi-mapped reads (using SAMtools with mapping quality > 0). [default: FALSE]
params.plot = "FALSE"
//	# If specified, plots of log-ratio distribution for each bin will be included in the output folder [default: FALSE]
params.minExon = "2000"
//	# Minimum number of exons in one bin (if less than this number, bin that contains small number of exons will be merged to the adjacent bins) [Default : 2000]
params.minControlRdForCall = "5"
//	# Minimum Control ReadDepth for call [Default: 5]
params.minTestRdForCall = "0"
//	# Minimum Test ReadDepth for call [Default: 0]
params.minAvgForCall = "20"
//	# Minimum average coverage for call [Default: 20]
params.maxRegionSize = "0"
//	# Maximum region size in target region (for breaking large regions into smaller regions. By default, maxRegionSize=0 means no breakdown). [Default : 0]
params.targetRegionSize = "200"
//	# Target region size for breakdown (if maxRegionSize is non-zero) [Default: 200]
params.largeDeletion = "False"
//	# If specified, CONTRA will run large deletion analysis (CBS). User must have DNAcopy R-library installed to run the analysis. [False]
params.smallSegment = "1"
//	# CBS segment size for calling large variations [Default : 1]
params.largeSegment = "25"
//	# CBS segment size for calling large variations [Default : 25]
params.lrCallStart = "-0.3"
//	# Log ratios start range that will be used to call CNV [Default : -0.3]
params.lrCallEnd = "0.3"
//	# Log ratios end range that will be used to call CNV [Default : 0.3]
params.passSize = "0.5"
//	# Size of exons that passed the p-value threshold compare to the original exons size [Default: 0.5]
params.removeDups = "False"
// (new since 2.0.6)
//	# if specified, will remove PCR duplicates [False]
params.version = ""
//	# Returns version
//////////////////////////////////////////////////////////////


log.info """\
    C O N T R A - N F   P I P E L I N E
    ===================================
    Target        : ${params.target}
    Sample        : ${params.sample}
    Control       : ${params.control}
    Reference     : ${params.reference}
    """
    .stripIndent()

// Define input channels
ch_target = Channel.fromPath(params.target)
ch_sample = Channel.fromPath(params.sample)
ch_control = Channel.fromPath(params.control)
ch_reference = Channel.fromPath(params.reference)
inputFiles = Channel.fromPath('samplesheet.csv')


// VALIDATION process for samplesheet.csv file
process VALIDATION {
    input:
    path inputFile
    
    output:
    stdout

    script:
    """
    #!/usr/bin/python3

    import csv
    import os

    # Define the expected structure and file extensions
    expected_structure = {
        "target": ".bed",
        "sample": ".bam",
        "control": ".bam",
        "reference": ".fasta",
        "output_dir": None  # No extension check for directories
    }

    def validate_csv(file_path):
        with open(file_path, mode='r') as file:
            reader = csv.reader(file)
            header = next(reader)
            
            # Check header
            if header != ["param", "path"]:
                print("Invalid header, header should be [param,path]")
                return False
            
            # Check rows
            for row in reader:
                if len(row) != 2:
                    print(f"Invalid row length: {row}")
                    return False
                
                param, path = row
                if param not in expected_structure:
                    print(f"Unexpected parameter: {param}")
                    return False
                
                expected_extension = expected_structure[param]
                if expected_extension and not path.endswith(expected_extension):
                    print(f"Invalid file extension for {param}: {path}")
                    return False
                
                # Check if path is valid for output_dir without checking existence
                if param == "output_dir" and not os.path.isabs(path):
                    print(f"Invalid path for output_dir: {path}")
                    return False
            
            #print("The samplesheet.csv file is valid")
            return True

    # Example usage
    file_path = "$inputFile"
    val_res = validate_csv(file_path)

    """
}

// CONTRA process
process CONTRA {
    container 'ishamada/contra:ver2'
    publishDir params.output_dir, mode: 'copy'

    input:
    path target
    path sample
    path control
    path reference

    output:
    path "${params.output_dir}"
    // path output_dir

    script:
    """
    python /contra/contra.py -t $target -s $sample -c $control -f $reference -o ${params.output_dir} \
    --numBin ${params.numBin} \
    --minReadDepth ${params.minReadDepth} \
    --minNBases ${params.minNBases} \
    --sam ${params.sam} \
    --pval ${params.pval} \
    --sampleName ${params.sampleName} \
    --nomultimapped ${params.nomultimapped} \
    --plot ${params.plot} \
    --minExon ${params.minExon} \
    --minControlRdForCall ${params.minControlRdForCall} \
    --minTestRdForCall ${params.minTestRdForCall} \
    --minAvgForCall ${params.minAvgForCall} \
    --maxRegionSize ${params.maxRegionSize} \
    --targetRegionSize ${params.targetRegionSize} \
    --largeDeletion ${params.largeDeletion} \
    --smallSegment ${params.smallSegment} \
    --largeSegment ${params.largeSegment} \
    --lrCallStart ${params.lrCallStart} \
    --lrCallEnd ${params.lrCallEnd} \
    --passSize ${params.passSize} \
    --removeDups ${params.removeDups} \
    --version ${params.version} \

    """
}

/*  --bed ${params.bed} \
*/   

workflow {
        
    res = VALIDATION(inputFiles)
    res.view { it }
    CONTRA(ch_target, ch_sample, ch_control, ch_reference)
}

workflow.onComplete {
    log.info(workflow.success ? "\nDone! Check the results of CONTRA > $params.output_dir/\n" : "Oops .. something went wrong" )
}