# TronFlow

[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)
[![Powered by Nextflow](https://img.shields.io/badge/powered%20by-Nextflow-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](https://www.nextflow.io/)
![Read the Docs](https://img.shields.io/readthedocs/tronflow-docs)


TronFlow is an open source collection of computational workflows originally conceived for tumor-normal somatic 
variant calling over whole exome data and the manipulation of BAM and VCF files with the aim of having comparable and 
analysis-ready data.
Over time, we have extended it to germline variant calling, copy numbers and other related technologies and analyses.

Its modular architecture covers different analytical and methodological use cases that allow analysing FASTQ files 
into analysis-ready and comparable results. They can be used independently or in combination.
These workflows are implemented in the Nextflow framework (Di Tommaso, 2017) and inspired by the community effort in 
NF-core (Ewels, 2020).
They use conda environments which enable a seamless installation, easy integration with cluster queue managers and 
ensure the reproducibility of results. 
Using tabular files as an interface to each module facilitate batch processing. 
The normalisation of variants and homogeneous technical annotations enable the comparison of variant calls from 
different pipelines. 

TronFlow workflows are publicly available on GitHub and open-sourced under the MIT license.
We actively seek feedback from the community to make the workflow robust to different use cases and datasets.

| Name                        | Description                                                                                                                                                                        | Repository                                                          | Latest release                                                                                                                      | DOI                                                                                             |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| Template                    | A template to start a new workflow. It contains the basic infrastructure for modular development and automated tests                                                               | https://github.com/TRON-Bioinformatics/tronflow-template            |                                                                                                                                     |                                                                                                 |
| Alignment                   | Alignment workflow supporting BWA aln, BWA mem and BWA mem2; specifically for RNA STAR is also supported                                                                           | https://github.com/TRON-Bioinformatics/tronflow-alignment           | ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-bwa?sort=semver)                 | [![DOI](https://zenodo.org/badge/327943420.svg)](https://zenodo.org/badge/latestdoi/327943420)  |
| BAM preprocessing           | GATK best practices flexible workflow including marking duplicates, base quality score recalibration (BQSR) and realignment around indels                                          | https://github.com/TRON-Bioinformatics/tronflow-bam-preprocessing   | ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-bam-preprocessing?sort=semver)   | [![DOI](https://zenodo.org/badge/358400957.svg)](https://zenodo.org/badge/latestdoi/358400957)  |
| Mutect2                     | GATK's Mutect2 best practices workflow for somatic variant calling                                                                                                                 | https://github.com/TRON-Bioinformatics/tronflow-mutect2             | ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-mutect2?sort=semver)             | [![DOI](https://zenodo.org/badge/355860788.svg)](https://zenodo.org/badge/latestdoi/355860788)  |
| GATK's HaplotypeCaller      | GATK's HaplotypeCaller best practices workflow for germline variant calling                                                                                                        | https://github.com/TRON-Bioinformatics/tronflow-haplotype-caller    | ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-haplotype-caller?sort=semver)    | [![DOI](https://zenodo.org/badge/437462852.svg)](https://zenodo.org/badge/latestdoi/437462852)  |
| LoFreq                      | LoFreq workflow for somatic variant calling                                                                                                                                        | https://github.com/TRON-Bioinformatics/tronflow-lofreq              |                                                                                                                                     |                                                                                                 |
| Strelka2                    | Strelka2 workflow for somatic variant calling                                                                                                                                      | https://github.com/TRON-Bioinformatics/tronflow-strelka2            |                                                                                                                                     |                                                                                                 |
| Somatic copy number calling | Workflow for somatic copy number calling on exomes supporting CNVkit and Sequenza                                                                                                  | https://github.com/TRON-Bioinformatics/tronflow-copy-number-calling |                                                                                                                                     |                                                                                                 |
| VCF postprocessing          | Flexible workflow including VCF normalization (Tan, 2015), technical annotations with VAFator, phasing with WhatsHap and functional annotations with either SnpEff or BCFtools csq | https://github.com/TRON-Bioinformatics/tronflow-vcf-postprocessing  | ![GitHub tag (latest SemVer)](https://img.shields.io/github/v/release/tron-bioinformatics/tronflow-vcf-postprocessing?sort=semver)  | [![DOI](https://zenodo.org/badge/372133189.svg)](https://zenodo.org/badge/latestdoi/372133189)  |


A more thorough documentation can be found here: https://tronflow-docs.readthedocs.io



## References

* Di Tommaso, Paolo, Maria Chatzou, Evan W Floden, Pablo Prieto Barja, Emilio Palumbo, and Cedric Notredame. “Nextflow Enables Reproducible Computational Workflows.” Nature Biotechnology 35, no. 4 (April 2017): 316–19. https://doi.org/10.1038/nbt.3820.
* Ewels, Philip A., Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso, and Sven Nahnsen. “The Nf-Core Framework for Community-Curated Bioinformatics Pipelines.” Nature Biotechnology 38, no. 3 (March 2020): 276–78. https://doi.org/10.1038/s41587-020-0439-x.
