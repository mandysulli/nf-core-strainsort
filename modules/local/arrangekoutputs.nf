process ARRANGEKOUTPUTS {
    tag { "${sample}" }
    label 'process_single'

    publishDir "${params.outdir}/kallisto_abundance_tsv", pattern: '*.tsv', mode: 'copy'
    publishDir "${params.outdir}/kallisto_pseudobam_files", pattern: '*.bam', mode: 'copy'

    input:
    tuple val(sample), path('*')

    output:
    path '*.bam', emit: bam
    path '*.tsv', emit: tsv
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    mv ./${sample}/abundance.tsv ./${sample}_abundance.tsv
    mv ./${sample}/pseudoalignments.bam ./${sample}_pseudoalignments.bam
    """
}
