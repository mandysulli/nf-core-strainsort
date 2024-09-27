process EXTRACTMAPREADSPE {
    tag { "${sample}" }
    label 'process_low'
    container 'staphb/samtools'

    publishDir "${params.outdir}/separated_fastqs", pattern: '*.fastq', mode: 'copy'

    input:
    tuple val(sample), path(sam_files), path(txt_files)

    output:
    val(sample), emit: sample_names
    path('incomplete_*_mapped_reads.sam'), emit: mapped_read_sam
    path(txt_files), emit: sam_headers
    path 'versions.yml'           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    shell:
    '''
    ### only grab mapped reads where both R1 and R2 map - need paired for spades to work
    cat !{sam_files} | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='83'||$2=='99'||$2=='147'||$2=='163') print $0}' > incomplete_!{sample}_mapped_reads.sam
    ### grab unmapped reads
    cat !{sam_files} | grep -v "^@" | awk 'BEGIN{FS="\t";OFS="\t"}{if($2=='77'||$2=='141') print $0}' > incomplete_!{sample}_unmapped_reads.sam
    cat !{txt_files} incomplete_!{sample}_unmapped_reads.sam > !{sample}_unmapped_reads.sam
    samtools view -S -b !{sample}_unmapped_reads.sam > !{sample}_unmapped_reads.bam
    samtools fastq !{sample}_unmapped_reads.bam -1 !{sample}_unmapped_R1.fastq -2 !{sample}_unmapped_R2.fastq

    rm !{sam_files}
    rm incomplete_!{sample}_unmapped_reads.sam
    rm !{sample}_unmapped_reads.bam

    cat <<-END_VERSIONS > versions.yml
    "!{task.process}":
        pseudobamtosam: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    '''

    stub:
    def args = task.ext.args ?: ''
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        extractmapreadspe: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
