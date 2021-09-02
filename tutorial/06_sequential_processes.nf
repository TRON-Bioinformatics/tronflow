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
    .splitCsv(header: ['language', 'hi', 'bye'], sep: "\t")
    .map{ row-> tuple(row.language, row.hi, row.bye)}

process sayHello {
  input:
    set name, surname, language, hi, bye from people.combine(dictionary)

  output:
   set file("${language}.txt"), name, surname, bye into say_bye_channel

  script:
    """
    echo '$hi $name $surname!' > ${language}.txt
    """
}

process sayBye {
  publishDir "${params.output_folder}/${surname}-${name}", mode: "copy"

  input:
   set file(input_file), name, surname, bye from say_bye_channel

  output:
   file("$input_file") into output_file

  script:
    """
    echo '$bye $name $surname!' >> ${input_file}
    """
}

