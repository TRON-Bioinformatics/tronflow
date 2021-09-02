#!/usr/bin/env nextflow


params.output_folder = false

if (! params.output_folder) {
    exit (-1, "Missing required output folder")
}

cheers = Channel.from 'Bonjour', 'Ciao', 'Hello', 'Hola'

process sayHello {
  publishDir params.output_folder, mode: "move"

  input:
    val x from cheers

  output:
   file "${x}.txt" into cheers_file

  script:
    """
    echo '$x '\$USER'!' > ${x}.txt
    """
}

