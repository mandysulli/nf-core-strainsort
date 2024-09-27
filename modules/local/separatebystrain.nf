process SEPARATEBYSTRAIN {
    tag { "${sample}" }
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container 'ubuntu'

    input:
    val(sample)
    path(mapped_read_sam)
    path(sam_headers_files)
    val(strain_names)
    path(lineage_txt_files)

    output:
    path '*.sam', emit: sam_files
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    grep -f ${strain_names}.txt incomplete_${sample}_mapped_reads.sam > incomplete_${sample}_${strain_names}_reads.sam
    cat sam_headers_${sample}.txt incomplete_${sample}_${strain_names}_reads.sam > ${sample}_${strain_names}_reads.sam

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
