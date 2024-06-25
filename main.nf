#!/usr/bin/env nextflow
// Dev version 2.1 #
// pipeline input parameters
params.target = "/home/islam/contra-test-data/0247401_D_BED_20090724_hg19_MERGED.bed"
params.sample = "/home/islam/contra-test-data/P0667T_GATKrealigned_duplicates_marked.bam"
params.control = "/home/islam/contra-test-data/P0667N_GATKrealigned_duplicates_marked.bam"
params.reference = "/home/islam/contra-test-data/human_g1k_v37.fasta"
params.output_dir = "results"

log.info """\
    C O N T R A - N F   P I P E L I N E
    ===================================
    Target        : ${params.target}
    Sample        : ${params.sample}
    Control       : ${params.control}
    Reference     : ${params.reference}
    """
    .stripIndent()

process CONTRA {
    publishDir params.output_dir, mode: 'copy'

    input:
    path "$params.target"

    output:
    path "$params.output_dir"
    // stdout

    script:
    """
    python /contra/contra.py -t $params.target -s $params.sample -c $params.control -f $params.reference -o $params.output_dir
    """
}

workflow {
    CONTRA(params.target)
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Check the results of CONTRA --> $params.output_dir/\n" : "Oops .. something went wrong" )
}