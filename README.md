# Classification of Single Locus Sequence Typing (SLST) in _Cutibacterium acnes_

## Introduction
sherrie-low/c_acnes_slst is a bioinformatics pipeline that uses raw metagenomic reads and classifies _C.acnes_ reads according to their SLSTs and measures the abundances of these strain types in each sample.

This pipeline is built using [Nextflow DSL2](https://www.nextflow.io/docs/latest/dsl2.html) and only accepts paired-end reads as inputs. 

## Pipeline summary 
1. Merging of paired end reads using vsearch(2.30.4)
2. Trimming of reads to get ~484bp amplicons using cutadapt(5.1)
3. Quality control using fastp(1.0.1)
4. Clustering of sequences using vsearch(2.30.4)
5. Parsing reads against _C.acnes_ SLST database using vsearch(2.30.4)

## Quick Start 
1. Install[`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=21.04.0`) and add the nextflow executable to your $PATH

2. Install Conda via any installer of choice (e.g. [`Miniforge`](https://github.com/conda-forge/miniforge))

3. Clone the pipeline to local repository 
	```sh 
	$ git clone https://github.com/sherrie-low/c_acnes_SLST
	```
	
4. Run the full workflow
	```sh 
	$ nextflow run main.nf 
	```
5. Obtain file containing SLST classification for downstream analysis 
	*This is a tab separated file containing the reads along with their matched SLST types in the output directory names hits, the raw files from the parsing is in the directory named hits.b6 

# Input
Absolute path to the folder containing the DNA reads. 

# Output 

* \*merged_reads: paired end reads that are merged
* \*trimmed_reads: reads starting with a consensus sequence were trimmed to obtain reads that are 480-488 bp long. This is to give 1% leeway of the actualy length of reads
* \*filtered_reads: reads that were filtered with an average_qual of 30 
* \*clustered_reads: fastq reads collapsed into a consensus sequence at 99% average nucleotide identity (ANI)
* \*parse: final output data used for downstream analysis 
  * \*hits.b6: raw blast6out files containing reads to their respective SLST matches. Columns are in [BLAST format](https://www.metagenomics.wiki/tools/blast/blastn-output-format-6)
  * \*hits.tsv: tab separated txt files of the blast6out format with additional second column containg read counts
  * \*no_hits: fasta file of the reads that did not meet 99% similarity match 
	

* \*discarded: reads that did not meet the criteria in each module.This contains unmerged reads,untrimmed reads and low quality reads. 

* \*log: summary logs of each module in the pipeline
  	* \*merge_logs: log of percentage of reads that merged and not merged, together with statsitics of the merged reads 
	* \*trim_stats: summary of number of amplicons generated and their length
	* \*qc_stats_txt: QC summary of the filtered reads
	* \*qc_reports : raw html and json files for each sample
	* \*cluster_log: summary of amplicon clusters and singletons generated 
	* \*parse_logs: summary of reads matched to the SLST database


## Contact
Sherrie Low : lowqrs@a-star.edu.sg 
