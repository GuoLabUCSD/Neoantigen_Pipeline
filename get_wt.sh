#! /bin/bash

#Get required arguments
usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") <args>

This script will extract wild-type junctions (junctions that share a start/end with the inputted junctions of interest list) and also create a separate junctions list for each sample.

Arguments:

-i      Path to a file of junctions
-b      Path to a Directory containing STAR's Log.final.out and SJ.tab.out files
-w	Path to a Directory containing STAR's Log.final.out and SJ.tab.out files for normal samples
-o      Output Directory to store files
-p	Path to Pipeline
-n      Prefix to what the output files should be named
-m	Data is from a mouse genome
EOF
  exit
}

while getopts "i:b:w:o:n:p:mh" flag ; do

        case "${flag}" in
                i) junctions_list=${OPTARG};;
                b) STAR_directory=${OPTARG};;
		w) STAR_directory_normal=${OPTARG};;
                o) output_directory=${OPTARG};;
                n) output_prefix=${OPTARG};;
		p) pipeline_directory=${OPTARG};;
		m) mouse='This_is_a_mouse_genome';;
                h) usage;;
        esac
done

if [ -z $junctions_list ] || [ -z $STAR_directory ] || [ -z $output_directory ] || [ -z $output_prefix ] || [ -z $pipeline_directory ] || [ -z $STAR_directory_normal ]; then
        echo "Missing required arguments"
        usage
        exit 1
fi

if [ ! -d $output_directory ]; then
        echo "The specified output directory does not exist"
        exit 1
fi

#Run Python Script
echo "Running"

if [ -z $mouse ]; then
	python $pipeline_directory/supplemental/human_identifyWTJunctions.py --junctions_list $junctions_list --STAR_directory $STAR_directory --STAR_directory_normal $STAR_directory_normal --output_directory $output_directory --output_prefix $output_prefix
else
	python $pipeline_directory/supplemental/mouse_identifyWTJunctions.py --junctions_list $junctions_list --STAR_directory $STAR_directory --STAR_directory_normal $STAR_directory_normal --output_directory $output_directory --output_prefix $output_prefix
fi

