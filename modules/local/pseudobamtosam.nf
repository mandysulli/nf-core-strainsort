process PSEUDOBAMTOSAM {
    tag { "${sample}" }
    label 'process_medium'
    container 'staphb/samtools'

    input:
    tuple val(sample), path (bam_files)

    output:
    tuple val(sample), path "*.sam", emit: sam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    samtools sort ${bam_files} > ${sample}_pseudoalignments_sorted.bam
    samtools index ${sample}_pseudoalignments_sorted.bam
    samtools view -h ${sample}_pseudoalignments_sorted.bam > ${sample}_pseudoalignments.sam
    grep "@" ${sample}_pseudoalignments.sam > $output/sam_headers_Sample.txt
    rm ${sample}_pseudoalignments_sorted.bai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pseudobamtosam: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    // TODO nf-core: A stub section should mimic the execution of the original module as best as possible
    //               Have a look at the following examples:
    //               Simple example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bcftools/annotate/main.nf#L47-L63
    //               Complex example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bedtools/split/main.nf#L38-L54
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pseudobamtosam: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
