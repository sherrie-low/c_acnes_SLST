#! usr/bin/env/ nextflow 

process QUALITY{
tag "$sample"


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
fastp -i ${trimmed_reads} -o ${sample}_filtered.fastq --average_qual 30 --failed_out ${sample}_failedreads.fastq -h ${sample}_fastp.html -j ${sample}_fastp.json &> ${sample}_fastp_summary.txt

"""

}
