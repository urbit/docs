#!/bin/bash

EDITOR=${EDITOR:-atom}

# build weights file
for file in $(find -type f -name \*.md); do
  [[ $file == *_index.md ]] && continue
  echo $(grep -m 1 "weight = " $file | sed 's/^weight = //') $file
done | sort -n > weights

# edit weights file
$EDITOR weights
read -p "Edit weights and press enter to continue..."

# for each line in weights file, read values weight and file, and update
# $weight in $file
cat weights | while read weight file; do
  echo $weight $file
  sed -i'' "s/^weight = [.0-9]*/weight = $weight/" $file
done

# remove weights file
rm weights