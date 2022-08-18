#!/bin/bash
IN=$1
OUT=$2
UNIQUE_PREFIX=$3

if [ -z "$IN" -o -z "$OUT" ]
then
  echo "generate_class_info_max_size.sh: Input file and output file arguments required!" >&2
  exit 1
fi

# get file size
BYTES=$(stat --format=%s "$IN")
if [ $? -ne 0 ]
then
  echo "generate_class_info_max_size.sh: 'stat' on input file failed!" >&2
  exit 2
fi

# size should be a multiple of 8 bytes
if [ $(($BYTES % 8)) -ne 0 ]
then
  BYTES=$((($BYTES / 8 + 1) * 8))
fi

# create folder if necessary
mkdir -p "$OUT"

# create header file
echo "#define ${UNIQUE_PREFIX}CLASS_INFO_MAX_SIZE $BYTES" > "$OUT/${UNIQUE_PREFIX}class_info_max_size.hpp"
exit 0