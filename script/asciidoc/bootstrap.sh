#!/bin/bash

# Clojure Cookbook Bootstrap
#
# If OSTYPE is Linux, you must supply
# the PACKAGER environment variable to indicate
# which one of pacman, apt, or yum should be used
# for package installation.
# Usage:
#     PACKAGER=apt ./bootstrap.sh
#
# Override the $SOURCE_HIGHLIGHT_DIR if you prefer to not
# alter the default source highlight installation.
# Usage:
#  $ SOURCE_HIGHLIGHT_DIR=/foo/bar ./script/asciidoc/bootstrap.sh
#
# Files will not be modified or replaced if they already exist
#
# Running this script more than once is OK.

set -e

if [[ "$OSTYPE" = "darwin"* ]]; then
    ASCIIDOC_INSTALL_CMD="brew install asciidoc"
    SOURCE_HIGHLIGHT_INSTALL_CMD="brew install source-highlight"
    SUDO=""
else
    # Let's go with Linux
    SUDO="sudo"
    case $PACKAGER in
        'apt')
            ASCIIDOC_INSTALL_CMD="$SUDO apt-get install asciidoc"
            SOURCE_HIGHLIGHT_INSTALL_CMD="$SUDO apt-get install source-highlight"
            ;;
        'yum')
            ASCIIDOC_INSTALL_CMD="$SUDO yum install asciidoc"
            SOURCE_HIGHLIGHT_INSTALL_CMD="$SUDO yum install source-highlight"
            ;;
        'pacman')
            ASCIIDOC_INSTALL_CMD="$SUDO pacman install asciidoc"
            SOURCE_HIGHLIGHT_INSTALL_CMD="$SUDO pacman install source-highlight"
            ;;
        *)
            echo "On Linux, $PACKAGER must be one of apt, pacman or yum"
            exit
            ;;
    esac
fi

echo "Begin Setup"

# Install asciidoc
command -v asciidoc >/dev/null 2>&1 || {
  echo "Installing asciidoc"
  $ASCIIDOC_INSTALL_CMD
}

# Install source-highlight
command -v source-highlight >/dev/null 2>&1 || {
  echo "Installing source-highlight"
  $SOURCE_HIGHLIGHT_INSTALL_CMD
}

if [[ -d "/usr/local/share/source-highlight" ]] ; then
    DEFAULT_SOURCE_HIGHLIGHT_DIR="/usr/local/share/source-highlight"
elif [[ -d "/usr/share/source-highlight" ]] ; then
    DEFAULT_SOURCE_HIGHLIGHT_DIR="/usr/share/source-highlight"
else
    echo "source-highlight directory not found."
    exit
fi

SOURCE_HIGHLIGHT_DIR="${SOURCE_HIGHLIGHT_DIR:-$DEFAULT_SOURCE_HIGHLIGHT_DIR}"
CLOJURE_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/clojure.lang"
JSON_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/json.lang"
JSON_STYLE_FILE="${SOURCE_HIGHLIGHT_DIR}/json.style"
TEXT_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/text.lang"

CLOJURE_LANG_SOURCE="https://gist.github.com/alandipert/265810/raw/8dec04317e02187b03e96bb1e0206e154e0ae5e2/clojure.lang"
JSON_LANG_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.lang"
JSON_STYLE_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.style"

# uncomment the following to debug/start fresh
# does not clean LANG_MAP_FILE
## rm $CLOJURE_LANG_FILE $JSON_LANG_FILE $JSON_STYLE_FILE $TEXT_LANG_FILE

# Clojure highlighting support
test -f "$CLOJURE_LANG_FILE" || (echo "********** Adding $CLOJURE_LANG_FILE **********" && $SUDO curl --location --silent --output "$CLOJURE_LANG_FILE" "$CLOJURE_LANG_SOURCE")

# JSON highlighting support
test -f "$JSON_LANG_FILE" || (echo "********** Adding $JSON_LANG_FILE **********" && $SUDO curl --location --silent --output "$JSON_LANG_FILE" "$JSON_LANG_SOURCE")
test -f "$JSON_STYLE_FILE" || (echo "********** Adding $JSON_STYLE_FILE **********" && $SUDO curl --location --silent --output "$JSON_STYLE_FILE" "$JSON_STYLE_SOURCE")

# CSV/text/text highlighting
# This is to avoid errors more than actually highlight anything.
test -f "$TEXT_LANG_FILE" || (echo "********** Adding $TEXT_LANG_FILE **********" && cat <<END | $SUDO tee "$TEXT_LANG_FILE" >/dev/null)
include "number.lang"
include "symbols.lang"
cbracket = "{|}"
END

LANG_MAP_FILE="$SOURCE_HIGHLIGHT_DIR/lang.map"

# Add mappings to $SOURCE_HIGHLIGHT_DIR/lang.map
# DO NOT REMOVE lang.map -- it has other mappings
(grep text.lang "$LANG_MAP_FILE" >/dev/null &&
 grep clojure.lang "$LANG_MAP_FILE" >/dev/null &&
 grep shell-session "$LANG_MAP_FILE" >/dev/null ) || {
  echo "********** Backing up original $LANG_MAP_FILE to ${LANG_MAP_FILE}.bak"
  $SUDO cp "$LANG_MAP_FILE" "${LANG_MAP_FILE}.bak"

  echo "********** Appending to $LANG_MAP_FILE"
  cat <<END | $SUDO tee -a "$LANG_MAP_FILE" >/dev/null

clojure = clojure.lang
csv = text.lang
json = json.lang
text = text.lang
shell-session=sh.lang
END

  echo "Cleaning $LANG_MAP_FILE"
  cleaned_contents="`sort "$LANG_MAP_FILE" | uniq`"
  echo "$cleaned_contents" | $SUDO tee "$LANG_MAP_FILE" >/dev/null
}

echo "Setup Complete"
