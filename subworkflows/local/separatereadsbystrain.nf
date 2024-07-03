/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { PSEUDOBAMTOSAM           } from "${launchDir}/modules/local/pseudobamtosam.nf"
include { EXTRACTMAPREADSPE        } from "${launchDir}/modules/local/extractmapreadspe.nf"
include { MAPSAMTOFASTQPE          } from "${launchDir}/modules/local/mapsamtofastqpe.nf"

workflow SEPARATEREADSBYSTRAIN {
    take:
    kallisto_bam_ch //channel: kallisto bam outputs

    main:
    ch_versions = Channel.empty()

    PSEUDOBAMTOSAM(kallisto_bam_ch)
    ch_versions = ch_versions.mix(PSEUDOBAMTOSAM.out.versions.first())

    EXTRACTMAPREADSPE(PSEUDOBAMTOSAM.out.sam_outputs)
    ch_versions = ch_versions.mix(EXTRACTMAPREADSPE.out.versions.first())

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
