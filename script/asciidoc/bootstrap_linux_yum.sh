#!/bin/bash

# Yum-based bootstrap script for setting up a Linux system to build
# Clojure Cookbook
#
# This script assumes your SOURCE_HIGHLIGHT_DIR is
# /usr/share/source-highlight. If it isn't, override the environment
# variable when you run this script:
#
#  $ SOURCE_HIGHLIGHT_DIR=/foo/bar ./script/asciidoc/bootstrap_yum.sh
#
# Files will not be modified or replaced if they already exist
#
# Running this script more than once is OK.

set -e

echo "Begin Setup"

# Install asciidoc
command -v asciidoc >/dev/null 2>&1 || {
  echo "Installing asciidoc"
  sudo yum -y install asciidoc
}

# Install source-highlight
command -v source-highlight >/dev/null 2>&1 || {
  echo "Installing source-highlight"
  sudo yum -y install source-highlight
}

# Install wget
command -v wget >/dev/null 2>&1 || {
  echo "Installing wget"
  sudo yum -y install wget
}

# Assume yum is going to use /usr/share/source-highlight
SOURCE_HIGHLIGHT_DIR="${SOURCE_HIGHLIGHT_DIR:-/usr/share/source-highlight}"
CLOJURE_LANG_FILE="source-highlight/clojure.lang"
JSON_LANG_FILE="source-highlight/json.lang"
JSON_STYLE_FILE="source-highlight/json.style"
TEXT_LANG_FILE="source-highlight/text.lang"

CLOJURE_LANG_SOURCE="https://gist.github.com/alandipert/265810/raw/8dec04317e02187b03e96bb1e0206e154e0ae5e2/clojure.lang"
JSON_LANG_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.lang"
JSON_STYLE_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.style"

# uncomment the following to debug/start fresh
# does not clean LANG_MAP_FILE
## rm $CLOJURE_LANG_FILE $JSON_LANG_FILE $JSON_STYLE_FILE $TEXT_LANG_FILE

mkdir -p source-highlight

# Clojure highlighting support
test -f "$CLOJURE_LANG_FILE" || (echo "********** Adding $CLOJURE_LANG_FILE **********" && curl --location --silent --output "$CLOJURE_LANG_FILE" "$CLOJURE_LANG_SOURCE")

# JSON highlighting support
test -f "$JSON_LANG_FILE" || (echo "********** Adding $JSON_LANG_FILE **********" && curl --location --silent --output "$JSON_LANG_FILE" "$JSON_LANG_SOURCE")
test -f "$JSON_STYLE_FILE" || (echo "********** Adding $JSON_STYLE_FILE **********" && curl --location --silent --output "$JSON_STYLE_FILE" "$JSON_STYLE_SOURCE")

# CSV/text/text highlighting
# This is to avoid errors more than actually highlight anything.
test -f "$TEXT_LANG_FILE" || (echo "********** Adding $TEXT_LANG_FILE **********" && cat <<END > "$TEXT_LANG_FILE")
include "number.lang"
include "symbols.lang"
cbracket = "{|}"
END

cp $SOURCE_HIGHLIGHT_DIR/* "source-highlight/"

LANG_MAP_FILE="source-highlight/lang.map"

# Add mappings to lang.map
# DO NOT REMOVE lang.map -- it has other mappings
(grep text.lang "$LANG_MAP_FILE" >/dev/null &&
 grep clojure.lang "$LANG_MAP_FILE" >/dev/null &&
 grep shell-session "$LANG_MAP_FILE" >/dev/null ) || {
#  echo "********** Backing up original $LANG_MAP_FILE to ${LANG_MAP_FILE}.bak"
#  cp "$LANG_MAP_FILE" "${LANG_MAP_FILE}.bak"

  echo "********** Appending to $LANG_MAP_FILE"
  cat <<END >> "$LANG_MAP_FILE"

clojure = clojure.lang
csv = text.lang
json = json.lang
text = text.lang
shell-session=sh.lang
END

  echo "Cleaning $LANG_MAP_FILE"
  cleaned_contents="`sort "$LANG_MAP_FILE" | uniq`"
  echo "$cleaned_contents" > "$LANG_MAP_FILE"

}

echo "Setup Complete"

