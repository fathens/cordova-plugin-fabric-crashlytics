#!/bin/bash
set -eu

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"

${prefix}-build_gradle.sh
${prefix}-MainActivity.sh
