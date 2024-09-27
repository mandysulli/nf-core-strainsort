/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { PSEUDOBAMTOSAM        } from "${launchDir}/modules/local/pseudobamtosam.nf"
include { EXTRACTMAPREADSPE     } from "${launchDir}/modules/local/extractmapreadspe.nf"
include { MAPSAMTOFASTQPE       } from "${launchDir}/modules/local/mapsamtofastqpe.nf"
include { LINEAGESETUP          } from "${launchDir}/modules/local/lineagesetup.nf"
include { SEPARATEBYSTRAIN      } from "${launchDir}/modules/local/separatebystrain.nf"

workflow SEPARATEPAIREDREADSBYSTRAIN {
    take:
    kallisto_bam_ch //channel: kallisto bam outputs

    main:
    java_lineage_ch = Channel.fromPath('./assets/lineage_file_setup_nf.java', checkIfExists: true)
    key_ch = Channel.fromPath(params.key, checkIfExists: true)
    ch_versions = Channel.empty()

    LINEAGESETUP(java_lineage_ch, key_ch)
    //Put the strainnames into a channel
    strain_names_input_ch = LINEAGESETUP.out.strain_names.splitCsv()
    strain_names_setup_ch = strain_names_input_ch.map { item ->
            [item[0]]
        }.distinct()
    strain_names_ch = strain_names_setup_ch.flatten()

    PSEUDOBAMTOSAM(kallisto_bam_ch)
    ch_versions = ch_versions.mix(PSEUDOBAMTOSAM.out.versions.first())

    EXTRACTMAPREADSPE(PSEUDOBAMTOSAM.out.sam_outputs)
    ch_versions = ch_versions.mix(EXTRACTMAPREADSPE.out.versions.first())

    //EXTRACTMAPREADSPE.out.mapped_read_sam.view()
    //LINEAGESETUP.out.lineage_txt.view()

    SEPARATEBYSTRAIN(EXTRACTMAPREADSPE.out.sample_names, EXTRACTMAPREADSPE.out.mapped_read_sam, EXTRACTMAPREADSPE.out.sam_headers, strain_names_ch, LINEAGESETUP.out.lineage_txt)

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
