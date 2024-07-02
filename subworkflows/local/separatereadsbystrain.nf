/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { PSEUDOBAMTOSAM           } from "${launchDir}/modules/local/pseudobamtosam.nf"

workflow SEPARATEREADSBYSTRAIN {
    take:
    kallisto_bam_ch //channel: kallisto bam outputs

    main:
    ch_versions = Channel.empty()

    PSEUDOBAMTOSAM(kallisto_bam_ch)
    ch_versions = ch_versions.mix(PSEUDOBAMTOSAM.out.versions.first())

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
