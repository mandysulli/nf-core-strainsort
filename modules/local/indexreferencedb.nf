process INDEXREFERENCEDB {
    tag 'Indexing reference database'
    label 'process_medium'
    container 'zavolab/kallisto:0.46.1'

    publishDir "${params.outdir}", pattern: '*.kallisto_idx', mode: 'copy'

    input:
    path ref_db

    output:
    path '*.kallisto_idx', emit: index
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    kallisto index -i sequences.kallisto_idx ${ref_db}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        indexreferencedb: \$(kallisto --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''

    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        indexreferencedb: \$(kallisto --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
