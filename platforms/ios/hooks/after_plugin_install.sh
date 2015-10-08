#!/bin/bash
set -eu

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"

${prefix}-podfile.sh
${prefix}-fix_xcodeproj.sh
${prefix}-initialize.sh
${prefix}-api_key.sh
