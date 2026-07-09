#! usr/bin/env nextflow 
 
process PARSE {

tag "${sample}"



output: 
tuple val(sample), path("${sample}_hits.tsv"),emit: matches,optional: true
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
mv ${sample}_hits.txt ${sample}_hits.tsv


"""
}
