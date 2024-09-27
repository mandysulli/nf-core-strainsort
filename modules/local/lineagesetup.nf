process LINEAGESETUP {
    tag 'lineage set up'
    label 'process_single'
    container 'bitnami/java:latest'

    input:
    val java_file
    val key

    output:
    path('All_strain_name.csv'), emit: strain_names
    path('*.txt'), emit: lineage_txt
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    javac ${java_file}
    cp  ${launchDir}/assets/lineage_file_setup_nf.class ./

    java lineage_file_setup_nf ${key}

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
