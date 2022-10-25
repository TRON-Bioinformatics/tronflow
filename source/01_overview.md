# TronFlow

[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)
[![Powered by Nextflow](https://img.shields.io/badge/powered%20by-Nextflow-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](https://www.nextflow.io/)


## Overview

TronFlow is an open source collection of computational workflows originally conceived for tumor-normal somatic 
variant calling over whole exome data and the manipulation of BAM and VCF files with the aim of having comparable and 
analysis-ready data.
Over time, we have extended it to germline variant calling, copy numbers and other related technologies and analyses.

Its modular architecture covers different analytical and methodological use cases that allow analysing FASTQ files 
into analysis-ready and comparable results. They can be used independently or in combination.
The workflows are implemented in the Nextflow framework (Di Tommaso, 2017) and inspired by the community effort in 
NF-core (Ewels, 2020).
They use conda environments which enable a seamless installation, easy integration with cluster queue managers and ensure the reproducibility of results. 
Using tabular files as an interface to each module facilitate batch processing. 
The normalisation of variants and homogeneous technical annotations enable the comparison of variant calls from 
different pipelines. 

TronFlow workflows are publicly available on GitHub and open-sourced under the MIT license.
We actively seek feedback from the community to make the workflow robust to different use cases and datasets.

| Name                        | Description                                                                                                                                                                        | Repository                                                          | DOI                                                      |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|----------------------------------------------------------|
| Template                    | A template to start a new workflow. It contains the basic infrastructure for modular development and automated tests                                                               | https://github.com/TRON-Bioinformatics/tronflow-template            |                                                          |
| Alignment                   | Alignment workflow supporting BWA aln, BWA mem and BWA mem2; specifically for RNA STAR is also supported                                                                           | https://github.com/TRON-Bioinformatics/tronflow-alignment           | [10.5281/zenodo.4722845](https://doi.org/10.5281/zenodo.4722845) |
| BAM preprocessing           | GATK best practices flexible workflow including marking duplicates, base quality score recalibration (BQSR) and realignment around indels                                          | https://github.com/TRON-Bioinformatics/tronflow-bam-preprocessing   | [10.5281/zenodo.4737238](https://doi.org/10.5281/zenodo.4737238) |
| Mutect2                     | GATK's Mutect2 best practices workflow for somatic variant calling                                                                                                                 | https://github.com/TRON-Bioinformatics/tronflow-mutect2             | [10.5281/zenodo.4722798](https://doi.org/10.5281/zenodo.4722798) |
| GATK's HaplotypeCaller      | GATK's HaplotypeCaller best practices workflow for germline variant calling                                                                                                        | https://github.com/TRON-Bioinformatics/tronflow-haplotype-caller    | [10.5281/zenodo.6588587](https://doi.org/10.5281/zenodo.6588587) |
| LoFreq                      | LoFreq workflow for somatic variant calling                                                                                                                                        | https://github.com/TRON-Bioinformatics/tronflow-lofreq              | [10.5281/zenodo.7248150](https://doi.org/10.5281/zenodo.7248150)                                                         |
| Strelka2                    | Strelka2 workflow for somatic variant calling                                                                                                                                      | https://github.com/TRON-Bioinformatics/tronflow-strelka2            | [10.5281/zenodo.7248185](https://doi.org/10.5281/zenodo.7248185)                                                            |
| Somatic copy number calling | Workflow for somatic copy number calling on exomes supporting CNVkit and Sequenza                                                                                                  | https://github.com/TRON-Bioinformatics/tronflow-copy-number-calling | [10.5281/zenodo.7248131](https://doi.org/10.5281/zenodo.7248131)                                                         |
| VCF postprocessing          | Flexible workflow including VCF normalization (Tan, 2015), technical annotations with VAFator, phasing with WhatsHap and functional annotations with either SnpEff or BCFtools csq | https://github.com/TRON-Bioinformatics/tronflow-vcf-postprocessing  | [10.5281/zenodo.4858666](https://doi.org/10.5281/zenodo.4858666)               |


## How to use

Nextflow allows to run pipelines from GitHub, this enables a seamless installation.

```
nextflow run tron-bioinformatics/tronflow-alignment --help
```

This will download the workflow from GitHub and cache it in your local folder under `~/.nextflow/assets`. 
You may delete workflows from this folder after use.

Make sure you use the latest version of every given workflow, unless you know what you are doing. 
It is a good idea to specify the version explicitly in your scripts for reproducibility purposes.

```
nextflow run tron-bioinformatics/tronflow-alignment -r v2.1.0
```

The history of releases of each workflow is documented in the corresponding GitHub releases section 
(e.g.: https://github.com/TRON-Bioinformatics/tronflow-vcf-postprocessing/releases).

To manage the dependencies we favour the use of conda. 
In particular, we recommend using miniconda as it has fewer dependencies in the base installation and hence the risk 
of conflict is lower.
We define the conda dependencies of each process within each workflow, we recommend using the conda profile to make 
sure that Nextflow uses conda. Alternatively you would need to install all dependencies locally before running the 
workflow.

```
nextflow run tron-bioinformatics/tronflow-alignment -profile conda,standard 
```

Remember you can configure your cluster of preference in your own standard profile.


## Use cases

The modular architecture of TronFlow allows to combine several of these workflows for different purposes.
Here we outline the different use cases that we have found useful to illustrate how to combine the different
building blocks to build pipelines adapted to different needs.

### Somatic variant calling

This is the original motivation of TronFlow, benchmarking multiple somatic variant callers by enabling comparable 
results from different variant callers. 
Here we outline the general steps, but depending on the particular requirements the pipeline shall be adapted.

The steps would roughly be:
- **Alignment**. We recommend to use BWA aln for 50 bp reads and BWA mem2 for anything above (with `--algorithm`). 
In this workflow there is a step to trim adaptor sequences with fastp, this can be skipped (with `--skip_trimming`).
- **BAM preprocessing**. Depending on the variant caller you may choose to perform some steps and not others. 
In general marking duplicates should not be skipped unless done before (`--skip_deduplication`). 
For Mutect2 it is recommended to use the Base Quality Score Recalibration (BQSR), but you may want to skip it for
other callers (`--skip_bqsr`). For Mutect2 it is not anymore recommended to use the realignment around indels (`--skip_realignment`)
- **Somatic variant calling**. Choose one or more from Mutect2, LoFreq and Strelka2.
- **VCF postprocessing**. This workflow contains several optional steps that depending on the downstream analysis 
requirements shall be used or not.
  - Variant normalization. Particularly useful to make the results from different callers comparable and depending on 
  the caller to make sure that mutations are represented in their normal form.
  - Technical annotations with VAFator. Annotations derived from the coverage and mutation supporting reads from the BAM files. 
  Useful when comparing things like VAFs from different variant caller results, different variant callers have
  different methods to calculate VAF and coverage.
  - Phasing with WhatsHap. This should be skipped for somatic mutations as only germline mutations with genotype calls are supported.
  - Functional annotations with either SnpEff or BCFtools csq. Annotations on the consequence of mutations in the overlapping gene products.


### Annotation of multiple tumor samples from the same patient

In the context of tumor evolution, it is useful to assess the somatic mutations in samples from different locations 
(eg: primary tumor and metastasis) or at different time points.
Variant callers annotate their variant calls with technical annotations which are very valuable. 
But unfortunately the calculation of these technical annotations cannot be easily decoupled from the variant calling 
process itself. This was the original motivation for VAFator which annotates a given VCF with technical annotations
from an arbitrary number of BAM files. Allowing for instance to annotate a given set of mutations with the VAFs from the
primary tumor, the metastasis and the normal; independently of whether they were called or not in these samples.

To perform such annotation you would need:
- **VCF postprocessing**
  - Variant normalization. To make sure that the calls from different samples are comparable you need to run this step
  which decomposes MNVs (eg: multiple SNVs reported together) and complex variants (eg: combinations of SNV and indel).
  - Technical annotations with VAFator. Make sure to pass all required BAM files with `--input_bams`, if purities 
  and/or local copy numbers are available these can also be passed with `--input_purities` and `--input_clonalities`.

The output VCF will enable the evaluation of any particular variant in all samples. 


### Germline variant calling

Multiple steps are common between somatic and germline variant calling.
Here we outline only those workflows with specific requirements for this use case.

- **BAM preprocessing**. Given that we will use the HaplotypeCaller it is recommended to use the 
Base Quality Score Recalibration (BQSR), for which you need to provide a dbSNP VCF (`--dbsnp`) and also skip the 
realignment around indels (`--skip_realignment`)
- Variant calling with **HaplotypeCaller**. It is recommened to perform the Variant Quality Score Recalibration for 
which you will need to provide the dbSNP VCF (`--dbsnp`), the 1000 Genomes + OMMI resource (`--thousand_genomes`) and
HapMap (`--hapmap`). All of these resources are available for download in different reference genomes in the GATK bundle.


### RNA variant calling

Calling mutations on RNA has its own challenges, but it may be convenient due to no available DNA or to combine with
results from DNA. Here we outline how to use the TronFlow workflows to perform RNA variant calling over RNA.

The required steps would be:
- **Alignment** with star (`--algorithm star`) using the two-pass mode (`--star_two_pass_mode`)
- **BAM preprocessing** splitting reads with Ns (`--split_cigarn`) and also because we will use the HaplotypeCaller skip
realignment around indels (`--skip_realignment`) and provide a dbSNP file (`--dbsnp`) so BQSR can be performed.
- Variant calling with the **HaplotypeCaller**. The main particularities are two: use a more stringent min confidence Phred 
score of 20 to emit mutations (`--min_quality 20`) and do not perform the Variant Quality Score Recalibration (`--skip_vqsr`).
The default hard filters when skipping VQSR are already adapted to RNA.


### Somatic copy number calling

Work in progress...


## Development guide

The TronFlow template provides a basic starting point to create a new Nextflow pipeline with the TronFlow structure. 
It includes: 
 - a dummy Nextflow script
 - a conda environment configuration
 - GitHub CI tests integration
 - a dummy test dataset including minimal FASTQ, BAM and VCF files
 - a dummy test minimal reference

For further details about Nextflow development there are several resources in the internet. 
See also, our own tutorial in ()[].


## How to cite

Use the specific DOIs of each workflow.


## References

* DePristo M, Banks E, Poplin R, Garimella K, Maguire J, Hartl C, Philippakis A, del Angel G, Rivas MA, Hanna M, McKenna A, Fennell T, Kernytsky A, Sivachenko A, Cibulskis K, Gabriel S, Altshuler D, Daly M. (2011). A framework for variation discovery and genotyping using next-generation DNA sequencing data. Nat Genet, 43:491-498. DOI: 10.1038/ng.806.
* Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319. 10.1038/nbt.3820
* Ewels, Philip A., Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso, and Sven Nahnsen. “The Nf-Core Framework for Community-Curated Bioinformatics Pipelines.” Nature Biotechnology 38, no. 3 (March 2020): 276–78. https://doi.org/10.1038/s41587-020-0439-x.
* Adrian Tan, Gonçalo R. Abecasis and Hyun Min Kang. Unified Representation of Genetic Variants. Bioinformatics (2015) 31(13): 2202-2204](http://bioinformatics.oxfordjournals.org/content/31/13/2202) and uses bcftools [Li, H. (2011). A statistical framework for SNP calling, mutation discovery, association mapping and population genetical parameter estimation from sequencing data. Bioinformatics (Oxford, England), 27(21), 2987–2993. 10.1093/bioinformatics/btr509
* Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H. Twelve years of SAMtools and BCFtools. Gigascience. 2021 Feb 16;10(2):giab008. doi: 10.1093/gigascience/giab008. PMID: 33590861; PMCID: PMC7931819.