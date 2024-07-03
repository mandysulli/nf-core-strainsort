process MAPSAMTOFASTQPE {
    tag '$bam'
    label 'process_medium'
    container 'staphb/samtools'

    input:

    output:

    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mapsamtofastqpe: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mapsamtofastqpe: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
