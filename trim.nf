#!/usr/bin/env nextflow

process TRIM{
tag "$sample"



output: 
tuple val(sample),path("${sample}_trimmed.fastq"),emit:trimmed, optional: true
path("${sample}_trim_stats.txt"), emit: trim_stats, optional: true

input:
tuple val (sample), path(merged_reads)


script: 
"""
cutadapt -g GTTGCACACCAGGGGGTCAACTTGG -m 480 -l 488 --discard-untrimmed --action=retain -o ${sample}_trimmed.fastq ${merged_reads}

awk 'NR%4==2 {print length (\$0)}' ${sample}_trimmed.fastq |sort -n |uniq -c > ${sample}_ampliconlengths.txt 

echo "Sample:${sample}" >${sample}_trim_stats.txt
echo '===Amplicon Length Distribution===' >> ${sample}_trim_stats.txt
cat ${sample}_ampliconlengths.txt >> ${sample}_trim_stats.txt
echo "" >> ${sample}_trim_stats.txt

trimmed_count=\$(awk 'END {print NR/4}' ${sample}_trimmed.fastq)
    echo "Total reads after trimming: \$trimmed_count" >> ${sample}_trim_stats.txt
    echo "" >> ${sample}_trim_stats.txt
"""
}


