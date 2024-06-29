process KALLISTO {
    tag { "${sample}" }
    label 'process_medium'
    container 'zavolab/kallisto:0.46.1'

    input:
    tuple val(sample), path(fastq_1), path(fastq_2)

    output:
    path '*.bam', emit: bam
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    kallisto quant \\
    -b 100 \\
    --pseudobam \\
    -i $index/sequences.kallisto_idx \\
    -o $output/{$sample} \\
    ${fastq_1} \\
    ${fastq_2}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        kallisto: \$(kallisto --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        kallisto: \$(kallisto --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
