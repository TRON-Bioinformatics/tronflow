# TronFlow overview

Welcome to the **TronFlow** documentation!

## About TronFlow

[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)
[![Powered by Nextflow](https://img.shields.io/badge/powered%20by-Nextflow-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](https://www.nextflow.io/)


TronFlow is a collection of computational workflows for tumor-normal pair somatic variant calling. 
Its modular architecture covers different analytical and methodological use cases that allow analysing FASTQ files 
into analysis-ready and comparable VCF files. 
The workflows are implemented in the Nextflow framework (Di Tommaso, 2017) using conda environments which enable a 
seamless installation, easy integration with cluster queue managers and ensure the reproducibility of results. 
Using tabular files as an interface to each module facilitate batch processing. 
The normalisation of variants and homogeneous technical annotations enable the comparison of variant calls from 
different pipelines. 
TronFlow workflows are publicly available on GitHub and open-sourced under the MIT license. 
They can be used independently or in combination.

| Name                 | Repository                                                             |
|----------------------|------------------------------------------------------------------------|
| Template             | https://github.com/TRON-Bioinformatics/tronflow-template               |
| BWA alignment        | https://github.com/TRON-Bioinformatics/tronflow-bwa                    |
| BAM preprocessing    | https://github.com/TRON-Bioinformatics/tronflow-bam-preprocessing      |
| Mutect2              | https://github.com/TRON-Bioinformatics/tronflow-mutect2                |
| VCF normalization    | https://github.com/TRON-Bioinformatics/tronflow-variant-normalization  |


## TronFlow template

Provides a basic template to create a new Nextflow pipeline with the TronFlow structure. 
It includes: 
 - a dummy Nextflow script
 - a conda environment configuration
 - GitLab CI tests integration
 - a dummy test dataset including minimal FASTQ, BAM and VCF files
 - a dummy test minimal reference

## BWA alignment

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-bwa?sort=semver)
[![DOI](https://zenodo.org/badge/327943420.svg)](https://zenodo.org/badge/latestdoi/327943420)

The TronFlow BWA alignment workflow implements both BWA mem and aln algorithms on single and paired-end data. 
Align FASTQs to a reference genome into BAM files.

Run it as follows:
```
nextflow run tron-bioinformatics/tronflow-bwa --help
```

For more details go to [https://github.com/TRON-Bioinformatics/tronflow-bwa](https://github.com/TRON-Bioinformatics/tronflow-bwa)


## BAM preprocessing

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-bam-preprocessing?sort=semver)
[![DOI](https://zenodo.org/badge/358400957.svg)](https://zenodo.org/badge/latestdoi/358400957)

The TronFlow BAM preprocessing workflow is a workhorse that allows readying BAM files through a flexible pipeline 
adaptable to different best practices using GATK and Picard.

GATK has been providing a well known best practices document on BAM preprocessing, the latest best practices for 
GATK4 (https://software.broadinstitute.org/gatk/best-practices/workflow?id=11165) do not perform anymore realignment 
around indels as opposed to best practices for 
GATK3 (https://software.broadinstitute.org/gatk/documentation/article?id=3238). 
This pipeline is based on both Picard and GATK. 
These best practices have been implemented a number of times, see for instance this implementation in 
Workflow Definition Language https://github.com/gatk-workflows/gatk4-data-processing/blob/master/processing-for-variant-discovery-gatk4.wdl.

We aim at providing a single implementation of the BAM preprocessing pipeline that can be used across different 
use cases.

Run it as follows:
```
nextflow run tron-bioinformatics/tronflow-bam-preprocessing --help
```

For more details go to [https://github.com/TRON-Bioinformatics/tronflow-bam-preprocessing](https://github.com/TRON-Bioinformatics/tronflow-bam-preprocessing)

## Mutect2

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-mutect2?sort=semver)
[![DOI](https://zenodo.org/badge/355860788.svg)](https://zenodo.org/badge/latestdoi/355860788)

The TronFlow Mutect2 workflow implements best practices somatic variant calling of tumour-normal pairs as published 
in Benjamin, 2019.

```
nextflow run tron-bioinformatics/tronflow-mutect2 --help
```

For more details go to [https://github.com/TRON-Bioinformatics/tronflow-mutect2](https://github.com/TRON-Bioinformatics/tronflow-mutect2)

## Variant normalization

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-variant-normalization?sort=semver)
[![DOI](https://zenodo.org/badge/372133189.svg)](https://zenodo.org/badge/latestdoi/372133189)

This pipeline aims at normalizing variants represented in a VCF into the convened normal form as described in Tan 2015. 
The variant normalization is based on the implementation in vt (Tan 2015) and bcftools (Danecek 2021).
 
The pipeline consists of the following steps:
 * Variant filtering (optional)
 * Decomposition of MNPs into atomic variants (ie: AC > TG is decomposed into two variants A>T and C>G) (optional).
 * Decomposition of multiallelic variants into biallelic variants (ie: A > C,G is decomposed into two variants A > C and A > G)
 * Trim redundant sequence and left align indels, indels in repetitive sequences can have multiple representations
 * Remove duplicated variants

Optionally if BAM files are provided (through `--bam_files`) VCFs are annotated with allele frequencies and depth of 
coverage by Vafator (https://github.com/TRON-Bioinformatics/vafator).

```
nextflow run tron-bioinformatics/tronflow-variant-normalization --help
```

For more details go to [https://github.com/TRON-Bioinformatics/tronflow-variant-normalization](https://github.com/TRON-Bioinformatics/tronflow-variant-normalization)

## References

* DePristo M, Banks E, Poplin R, Garimella K, Maguire J, Hartl C, Philippakis A, del Angel G, Rivas MA, Hanna M, McKenna A, Fennell T, Kernytsky A, Sivachenko A, Cibulskis K, Gabriel S, Altshuler D, Daly M. (2011). A framework for variation discovery and genotyping using next-generation DNA sequencing data. Nat Genet, 43:491-498. DOI: 10.1038/ng.806.
* Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319. 10.1038/nbt.3820
* Adrian Tan, Gonçalo R. Abecasis and Hyun Min Kang. Unified Representation of Genetic Variants. Bioinformatics (2015) 31(13): 2202-2204](http://bioinformatics.oxfordjournals.org/content/31/13/2202) and uses bcftools [Li, H. (2011). A statistical framework for SNP calling, mutation discovery, association mapping and population genetical parameter estimation from sequencing data. Bioinformatics (Oxford, England), 27(21), 2987–2993. 10.1093/bioinformatics/btr509
* Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H. Twelve years of SAMtools and BCFtools. Gigascience. 2021 Feb 16;10(2):giab008. doi: 10.1093/gigascience/giab008. PMID: 33590861; PMCID: PMC7931819.