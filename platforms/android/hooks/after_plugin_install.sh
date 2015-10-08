#!/bin/bash
set -eu

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"
cd "$1"

${prefix}-build_gradle.sh
${prefix}-MainActivity.sh
