#!/usr/bin/env nextflow

// Define input parameters
params.target = "/home/islam/contra-data/0247401_D_BED_20090724_hg19_MERGED.bed"
params.sample = "/home/islam/contra-data/P0667T_GATKrealigned_duplicates_marked.bam"
params.control = "/home/islam/contra-data/P0667N_GATKrealigned_duplicates_marked.bam"
params.reference = "/home/islam/contra-data/human_g1k_v37.fasta"
params.output_dir = "results"

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