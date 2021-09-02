#!/usr/bin/env nextflow


params.output_folder = false

if (! params.output_folder || ! params.people) {
    exit (-1, "Missing required parameter")
}

people = Channel
    .fromPath(params.people)
    .splitCsv(header: ['name', 'surname'], sep: "\t")
    .map{ row-> tuple(row.name, row.surname)}

dictionary = Channel
    .fromPath(params.dictionary)
    .splitCsv(header: ['language', 'hi'], sep: "\t")
    .map{ row-> tuple(row.language, row.hi)}

process sayHello {
  publishDir "${params.output_folder}/${surname}-${name}", mode: "move"

  input:
    set name, surname, language, hi from people.combine(dictionary)

  output:
   file "${language}.txt" into cheers_file

  script:
    """
    echo '$hi $name $surname!' > ${language}.txt
    """
}

