#!/usr/bin/env nextflow


params.output_folder = false
params.fasta = false
params.mhc = false

netmhcpan = "/code/net/MHCpan/4.0/netMHCpan"

if (! params.output_folder || ! params.fasta || ! params.mhc) {
    exit (-1, "Missing required parameter")
}

proteins = Channel
    .fromPath(params.fasta)
    .splitFasta()

mhc = Channel.from(params.mhc.split(","))


process runNetMhcPan {
  input:
    set protein, mhc from proteins.combine(mhc)

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

    # run netMHCpan, remove comments and empty lines and select first 20 lines
    $netmhcpan -s -f input.fasta -a $mhc \
    | grep -v '#' \
    | grep -v '^\$' \
    | head -20 >> ${uuid}.netmhcpan
    """
}

process mergeResults {
    publishDir "${params.output_folder}", mode: "copy"

    input:
        file list_results_netmhcpan from results_netmhcpan.collect()

    output:
        file "all_results.netmhcpan" into all_results

    script:
        """
        cat $list_results_netmhcpan > all_results.netmhcpan
        """
}
