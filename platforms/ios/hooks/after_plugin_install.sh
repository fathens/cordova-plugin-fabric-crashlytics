#!/bin/bash
set -eu

plugin_id=$1

grep SWIFT_OBJC_BRIDGING_HEADER $(find . -maxdepth 2 -name 'project.pbxproj') || echo 'NONE'

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"

subrun() {
    time ${prefix}-$1.sh "$plugin_id"
}

cat <<EOF | while read name; do subrun "$name"; done
podfile
fix_xcodeproj
initialize
api_key
EOF
