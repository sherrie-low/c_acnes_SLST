#! usr/bin/env nextflow 

process CLUSTER{
tag "$sample"


output:
tuple val(sample), path("${sample}_clustered.fasta"), emit: clustered,optional:true
path("${sample}_unclustered.fasta"),emit: unmatched,optional: true
path("${sample}.uc"), emit:uc, optional:true 
path("${sample}_cluster.log"), emit:stats,optional:true


input: 
tuple val(sample), path(filtered_reads)

script: 
""" 

vsearch --cluster_fast ${filtered_reads} --id 0.99 --centroids ${sample}_clustered.fasta --notmatched ${sample}_unclusterd.fasta --sizeout --uc ${sample}.uc --log ${sample}_cluster.log


"""
}
