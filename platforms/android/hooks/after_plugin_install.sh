#!/bin/bash
set -eu

prefix="$(cd $(dirname $0); pwd)/after_plugin_install"

subrun() {
    time ${prefix}-$1.sh
}

cat <<EOF | while read name; do subrun "$name"; done
build_gradle
MainActivity
EOF
