#!/usr/bin/env nextflow

process MERGE {

 
tag "$sample"


output: 
tuple val(sample), path("${sample}_merged.fastq"), emit:merged, optional: true
tuple val(sample), path("${sample}_unmerged_R1.fastq"),path("${sample}_unmerged_R2.fastq"),emit:unmerged, optional: true
path("${sample}_merge.log"), emit: log , optional: true 

input: 
tuple val(sample),path(read_1),path(read_2)

script:

"""
echo "Processing ${sample}.."
vsearch --fastq_mergepairs $read_1 --reverse $read_2 --fastqout "${sample}_merged.fastq" --fastqout_notmerged_fwd "${sample}_unmerged_R1.fastq" --fastqout_notmerged_rev "${sample}_unmerged_R2.fastq" -log "${sample}_merge.log"

"""
}


