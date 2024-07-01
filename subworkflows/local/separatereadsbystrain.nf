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

    ARRANGEKOUTPUTS(kallisto_bam_ch)
    ch_versions = ch_versions.mix(ARRANGEKOUTPUTS.out.versions.first())

    emit:
    versions = ch_versions                     // channel: [ versions.yml ]
}
