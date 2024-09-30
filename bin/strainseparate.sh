#!/bin/bash

while getopts 's:i:o:na' OPTION; do
    case "$OPTION" in
    s) strain_names="$OPTARG" ;;
    i) sample="$OPTARG" ;;
    *) usage ;;
    esac
done

grep -f "$strain_names".txt incomplete_"$sample"_mapped_reads.sam >incomplete_"$sample"_"$strain_names"_reads.sam
cat sam_headers_"$sample".txt incomplete_"$sample"_"$strain_names"_reads.sam >"$sample"_"$strain_names"_reads.sam
