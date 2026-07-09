#!/usr/bin/env nextflow

nextflow.enable.dsl= 2 

rawreads_Ch = Channel.fromFilePairs('/mnt/c/Users/lowqrs/workspace/C_acnes_SLST/nextflow-slst/git_test/*_{1,2}.fastq',flat: true)
                                                .view()

include {MERGE} from './merge.nf'
include {TRIM} from './trim.nf'
include {QUALITY} from './quality.nf'
include {CLUSTER} from './cluster.nf'
include {PARSE} from './parse.nf'

workflow {

merge_out = MERGE(rawreads_Ch)
	merge_out.merged.view {"MERGE:${it}"}

trim_out = TRIM(merge_out.merged)
	trim_out.trimmed.view {"TRIM:${it}"}
	trim_out.trim_stats.view{"Stats:{$it}"}

filter_out = QUALITY(trim_out.trimmed)
	filter_out.filtered.view {"QUALITY:${it}"}

cluster_out = CLUSTER(filter_out.filtered)
	cluster_out.clustered.view {"CLUSTER:${it}"}
	cluster_out.stats.view {"Stats:{$it}"}

db_ch = channel.fromPath('C_acnes_SLSTs.fa').collect()

parse_out = PARSE(cluster_out.clustered,db_ch)
	parse_out.matches.view {"PARSE ${it}"}
}	
