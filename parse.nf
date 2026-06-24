#! usr/bin/env nextflow 
 
process PARSE {

tag "${sample}"

publishDir 'results/hits',mode:'copy',pattern:'*_hits.txt'
publishDir 'results/hits.b6',mode:'copy', pattern:'*.hits.b6' 
publishDir 'results/no_hits',mode:'copy', pattern:'*_nohits.fasta'
publishDir 'results/parse_error_log',mode:'copy', pattern:'*.log'
publishDir 'results/parse_logs', mode: 'copy', pattern:'*_vsearch.log'


output: 
tuple val(sample), path("${sample}_hits.txt"),emit: matches,optional: true
tuple val(sample), path("${sample}.hits.b6"), emit: hits_b6,optional: true
tuple val(sample), path("${sample}_nohits.fasta"), emit:unmatched, optional:true
path("${sample}_vsearch.log"),emit:stats,optional:true

input: 
tuple val(sample),path(clustered_reads)
each path(db)

script: 
"""

vsearch --usearch ${clustered_reads} --db ${db} --id 0.99 --blast6out ${sample}.hits.b6 --notmatched ${sample}_nohits.fasta --strand both --log ${sample}_vsearch.log

awk -F ";size=" -v OFS="\t" '{print \$1,\$2}' ${sample}.hits.b6 > ${sample}_hits.txt


"""
}
