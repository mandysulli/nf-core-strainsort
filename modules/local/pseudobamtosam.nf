process PSEUDOBAMTOSAM {
    tag { "${sample}" }
    label 'process_medium'
    container 'staphb/samtools'

    input:
    tuple val(sample), path(bam_files)

    output:
    tuple val(sample), path('*.sam'), path('*.txt'), emit: sam_outputs
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    samtools sort ${bam_files} > ${sample}_pseudoalignments_sorted.bam
    samtools index ${sample}_pseudoalignments_sorted.bam
    samtools view -h ${sample}_pseudoalignments_sorted.bam > ${sample}_pseudoalignments.sam
    grep "@" ${sample}_pseudoalignments.sam > sam_headers_${sample}.txt

    rm ${sample}_pseudoalignments_sorted.bam.bai
    rm ${sample}_pseudoalignments_sorted.bam
    rm ${sample}_pseudoalignments.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pseudobamtosam: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pseudobamtosam: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
