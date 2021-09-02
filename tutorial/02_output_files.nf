#!/usr/bin/env nextflow

cheers = Channel.from 'Bonjour', 'Ciao', 'Hello', 'Hola'

process sayHello {
  input: 
    val x from cheers

  output:
   file "${x}.txt" into cheers_file

  script:
    """
    echo '$x '\$USER'!' > ${x}.txt
    """
}

