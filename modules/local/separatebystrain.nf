process SEPARATEBYSTRAIN {
    tag { "${sample}" }
    label 'process_low'
    container 'staphb/samtools'

    input:
    tuple val(sample), path(mapped_read_sam), path(sam_headers_files), val(strain_names), path(lineage_txt_files)

    output:
    tuple val(sample), path('*.sam'), emit: sam_files
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    chmod 777 ${launchDir}/bin/strainseparate.sh
    ${launchDir}/bin/strainseparate.sh -s ${strain_names} -i ${sample}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        separatebystrain: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        separatebystrain: \$(bash --version |& sed '1!d ; s/bash //')
    END_VERSIONS
    """
}
