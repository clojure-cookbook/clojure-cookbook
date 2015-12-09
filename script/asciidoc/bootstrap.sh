#!/bin/bash

# Clojure Cookbook Bootstrap
#
# This script will attempt to determine your local package manager (e.g. brew,
# apt-get, yum or install) to install dependencies
#
# If your packager is not in the list above, you will need to specify a package
# installation command via $PACKAGE_INSTALL
#
# Usage:
#     PACKAGE_INSTALL="sudo <my-packager> install" ./bootstrap.sh
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

# Determine package installation command
if [[ -n "$PACKAGE_INSTALL" ]]; then
  echo "Using '$PACKAGE_INSTALL' as install command"
elif [[ "$OSTYPE" = "darwin"* ]]; then
  PACKAGE_INSTALL="brew install"
elif command -v apt-get >/dev/null 2>&1; then
  PACKAGE_INSTALL="sudo apt-get install"
elif command -v yum >/dev/null 2>&1; then
  PACKAGE_INSTALL="sudo yum install"
elif command -v pacman >/dev/null 2>&1; then
  PACKAGE_INSTALL="sudo pacman --noconfirm -S"
else
  echo "Unable to determine local package manager. Provide one via \$PACKAGE_INSTALL like \"sudo <my-packager> install\""
fi

echo "Beginning Setup..."

# Install asciidoc
command -v asciidoc >/dev/null 2>&1 || {
  echo "Installing asciidoc"
  $PACKAGE_INSTALL asciidoc
}

# Install source-highlight
command -v source-highlight >/dev/null 2>&1 || {
  echo "Installing source-highlight"
  $PACKAGE_INSTALL "source-highlight"
}


if [[ -n "$SOURCE_HIGHLIGHT_DIR" ]]; then
  echo "Using source-highlight directory '$SOURCE_HIGHLIGHT_DIR'"
elif [[ -d "/usr/local/share/source-highlight" ]] ; then
  SOURCE_HIGHLIGHT_DIR="/usr/local/share/source-highlight"
elif [[ -d "/usr/share/source-highlight" ]] ; then
  SOURCE_HIGHLIGHT_DIR="/usr/share/source-highlight"
elif [[ -d "/opt/local/share/source-highlight" ]] ; then
  SOURCE_HIGHLIGHT_DIR="/opt/local/share/source-highlight"
else
  echo "source-highlight directory not found. Provide one via \$SOURCE_HIGHLIGHT_DIR"
  exit
fi

CLOJURE_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/clojure.lang"
JSON_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/json.lang"
JSON_STYLE_FILE="${SOURCE_HIGHLIGHT_DIR}/json.style"
TEXT_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/text.lang"

CLOJURE_LANG_SOURCE="https://gist.github.com/alandipert/265810/raw/8dec04317e02187b03e96bb1e0206e154e0ae5e2/clojure.lang"
JSON_LANG_SOURCE="https://raw.githubusercontent.com/freeformsystems/rlx/13f9b3f728d9a64299e118fc8a2ecfa29b60d42e/lib/highlight/json.lang"
JSON_STYLE_SOURCE="https://raw.githubusercontent.com/freeformsystems/rlx/13f9b3f728d9a64299e118fc8a2ecfa29b60d42e/lib/highlight/json.style"

# uncomment the following to debug/start fresh
# does not clean LANG_MAP_FILE
## rm $CLOJURE_LANG_FILE $JSON_LANG_FILE $JSON_STYLE_FILE $TEXT_LANG_FILE

# Clojure highlighting support
test -f "$CLOJURE_LANG_FILE" || (echo "** Adding $CLOJURE_LANG_FILE **" && sudo curl --location --silent --output "$CLOJURE_LANG_FILE" "$CLOJURE_LANG_SOURCE")

# JSON highlighting support
test -f "$JSON_LANG_FILE" || (echo "** Adding $JSON_LANG_FILE **" && sudo curl --location --silent --output "$JSON_LANG_FILE" "$JSON_LANG_SOURCE")
test -f "$JSON_STYLE_FILE" || (echo "** Adding $JSON_STYLE_FILE **" && sudo curl --location --silent --output "$JSON_STYLE_FILE" "$JSON_STYLE_SOURCE")

# CSV/text/text highlighting
# This is to avoid errors more than actually highlight anything.
test -f "$TEXT_LANG_FILE" || (echo "** Adding $TEXT_LANG_FILE **" && cat <<END | sudo tee "$TEXT_LANG_FILE" >/dev/null)
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
  echo "** Backing up original $LANG_MAP_FILE to ${LANG_MAP_FILE}.bak"
  $SUDO cp "$LANG_MAP_FILE" "${LANG_MAP_FILE}.bak"

  echo "** Appending to $LANG_MAP_FILE"
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
