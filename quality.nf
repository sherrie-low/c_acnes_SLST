#! usr/bin/env/ nextflow 

process QUALITY{
tag "$sample"

publishDir 'results/filtered_reads', mode:'copy',pattern:'*_filtered.fastq'
publishDir 'results/qc_reports', mode: 'copy', pattern:'*.html'
publishDir 'results/qc_reports',mode:'copy', pattern:'*.json'
publishDir 'results/low_quality_reads', mode:'copy', pattern:'*_failedreads.fastq'
publishDir 'results/qc_stats_txt', mode : 'copy', pattern :'*.txt'

output: 
tuple val(sample), path("${sample}_filtered.fastq"),emit: filtered, optional : true
tuple val(sample), path("${sample}_failedreads.fastq"), optional : true
tuple val(sample), path("${sample}_fastp_summary.txt"),optional : true 
path "${sample}_fastp.html", emit: html_reports, optional: true
path "${sample}_fastp.json",emit: json_reports, optional:true
 

input: 
tuple val(sample), path(trimmed_reads)

script: 

"""
fastp -i ${trimmed_reads} -o ${sample}_filtered.fastq --average_qual 30 --failed_out ${sample}_failedreads.fastq -h ${sample}_fastp.html -j ${sample}_fastp.json >2 ${sample}_fastp_summary.txt

"""

}
