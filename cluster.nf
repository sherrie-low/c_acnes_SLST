#! usr/bin/env nextflow 

process CLUSTER{
tag "$sample"

publishDir 'results/clustered_reads', mode: 'copy', pattern:'*_clustered.fasta'
publishDir 'results/unclusterd_reads', mode:'copy', pattern:'*_unclustered.fasta'
publishDir 'results/cluster_uc', mode:'copy',pattern:'*.uc'
publishDir 'results/cluster_log', mode:'copy', pattern:'*_cluster.log'

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
