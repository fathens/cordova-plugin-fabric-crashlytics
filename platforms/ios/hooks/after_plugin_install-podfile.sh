#!/bin/bash
set -eu

echo "################################"
echo "#### Add to Podfile"

cat <<EOF >> Podfile
pod 'Fabric'
pod 'Crashlytics'
EOF
