process LINEAGESETUP {
    tag 'lineage set up'
    label 'process_single'
    container 'bitnami/java:latest'

    input:
    val java_file
    val key

    output:
    path('*'), emit: bam
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    javac ${java_file}
    cp  ${launchDir}/assets/lineage_file_setup.class ./

    java lineage_file_setup ${key}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        lineagesetup: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        lineagesetup: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
