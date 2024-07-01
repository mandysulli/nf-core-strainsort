/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
//include { ARRANGEKOUTPUTS           } from '../modules/local/arrangekoutputs.nf'

workflow SEPARATEREADSBYSTRAIN {
    take:
    kallisto_bam_ch //channel: kallisto bam outputs

    main:
    ch_versions = Channel.empty()

    ARRANGEKOUTPUTS(kallisto_outputs_ch)
    ch_versions = ch_versions.mix(ARRANGEKOUTPUTS.out.versions.first())

    SAMTOOLS_INDEX(SAMTOOLS_SORT.out.bam)
    ch_versions = ch_versions.mix(SAMTOOLS_INDEX.out.versions.first())

    emit:
    // TODO nf-core: edit emitted channels
    bam      = SAMTOOLS_SORT.out.bam           // channel: [ val(meta), [ bam ] ]
    bai      = SAMTOOLS_INDEX.out.bai          // channel: [ val(meta), [ bai ] ]
    csi      = SAMTOOLS_INDEX.out.csi          // channel: [ val(meta), [ csi ] ]

    versions = ch_versions                     // channel: [ versions.yml ]
}
