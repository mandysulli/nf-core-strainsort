/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { PSEUDOBAMTOSAM        } from "${launchDir}/modules/local/pseudobamtosam.nf"
include { EXTRACTMAPREADSPE     } from "${launchDir}/modules/local/extractmapreadspe.nf"
include { MAPSAMTOFASTQPE       } from "${launchDir}/modules/local/mapsamtofastqpe.nf"
include { LINEAGESETUP          } from "${launchDir}/modules/local/lineagesetup.nf"

workflow SEPARATEREADSBYSTRAIN {
    take:
    kallisto_bam_ch //channel: kallisto bam outputs

    main:
    java_lineage_ch = Channel.fromPath('./assets/lineage_file_setup.java', checkIfExists: true)
    key_ch = Channel.fromPath(params.key, checkIfExists: true)
    ch_versions = Channel.empty()

    LINEAGESETUP(java_lineage_ch, key_ch)

    PSEUDOBAMTOSAM(kallisto_bam_ch)
    ch_versions = ch_versions.mix(PSEUDOBAMTOSAM.out.versions.first())

    EXTRACTMAPREADSPE(PSEUDOBAMTOSAM.out.sam_outputs)
    ch_versions = ch_versions.mix(EXTRACTMAPREADSPE.out.versions.first())

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
