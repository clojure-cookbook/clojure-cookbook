#!/bin/bash

# A script to check that every AsciiDoc file is in included in the book via a
# "include::" directive.
for filename in `find . -name "*.asciidoc"`; do
  # Skip the root conventions, it is a false positive.
  if [ $filename == "./conventions.asciidoc" ] ||
     [ $filename == "./clojure-cookbook.asciidoc"]; then
    continue
  fi

  # Remove a level of slashes, for example:
  # ./chapter/recipe/recipe.asciidoc -> recipe/recipe.asciidoc
  include_name="${filename#*/*/}"

  ack "include::.*$include_name" &> /dev/null ||
    echo "Recipe not included: $filename"
done

