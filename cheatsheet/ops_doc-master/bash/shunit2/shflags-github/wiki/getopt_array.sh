#! /bin/bash
# getopt_array.sh -t one -t two

while getopts ":t:" opt; do
  case $opt in
    t)
      TAGS+=($OPTARG)
      ;;
  esac
done
shift $((OPTIND-1))

for $tag in "${TAGS[@]}"; do
  echo "Tag: $tag"
done

