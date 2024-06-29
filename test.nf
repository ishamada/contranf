#!/usr/bin/env nextflow
// Dev version 2.2 # Author:islam.salah@gmail.com

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

// Define input channels
ch_target = Channel.fromPath(params.target)
ch_sample = Channel.fromPath(params.sample)
ch_control = Channel.fromPath(params.control)
ch_reference = Channel.fromPath(params.reference)

process CONTRA {
    publishDir params.output_dir, mode: 'copy'

    input:
    path target
    path sample
    path control
    path reference

    output:
    path "${params.output_dir}"

    script:
    """
    python /contra/contra.py -t $target -s $sample -c $control -f $reference -o ${params.output_dir}
    """
}

workflow {
    CONTRA(ch_target, ch_sample, ch_control, ch_reference)
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Check the results of CONTRA > $params.output_dir/\n" : "Oops .. something went wrong" )
}