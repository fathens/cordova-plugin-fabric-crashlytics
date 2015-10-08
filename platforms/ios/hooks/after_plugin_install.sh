#!/bin/bash
set -eu

plugin_id=$1

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"

${prefix}-podfile.sh
${prefix}-fix_xcodeproj.sh "$plugin_id"
${prefix}-initialize.sh
${prefix}-api_key.sh
