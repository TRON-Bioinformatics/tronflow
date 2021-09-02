#!/usr/bin/env nextflow


params.output_folder = false
params.fasta = false
params.proteome = false

if (! params.output_folder || ! params.fasta || ! params.proteome) {
    exit (-1, "Missing required parameter")
}

proteins = Channel
    .fromPath(params.fasta)
    .splitFasta()


process runBlastp {
  conda "bioconda::blast"
  cpus 4
  memory "8g"

  input:
    val protein from proteins

  output:
    file("${uuid}.netmhcpan") into results_netmhcpan

  script:
    // we need a Universally Unique Identifier to generate unique output names
    uuid = UUID.randomUUID().toString()
    """
    # netMHCpan needs that the amino acids sequence is passed through FASTA files
    echo "$protein" > input.fasta

    # log in the output file the whole query sequence
    echo "QUERY:
    $protein" > ${uuid}.netmhcpan

    # run blastp
    blastp -gapopen 11 -gapextend 1 -outfmt 5 \
    -query input.fasta -db ${params.proteome} -evalue 100000000 \
    -num_threads ${task.cpus} \
    >> ${uuid}.netmhcpan
    """
}

process mergeResults {
    cpus 1
    memory "1g"

    publishDir "${params.output_folder}", mode: "copy"

    input:
        file list_results_blastp from results_netmhcpan.collect()

    output:
        file "all_results.blastp" into all_results

    script:
        """
        cat $list_results_blastp > all_results.blastp
        """
}
