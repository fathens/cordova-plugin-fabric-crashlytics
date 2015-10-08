#!/bin/bash
set -eu

echo "################################"
echo "#### Fix project.pbxproj"

proj="$(find . -maxdepth 1 -name '*.xcodeproj')"
echo "Fixing $(pwd)/$proj"

cat <<EOF | ruby
require 'xcodeproj'

project = Xcodeproj::Project.open "$proj"

project.targets.each do |target|
    phase = target.new_shell_script_build_phase "Fabric"
    phase.shell_script = "./Pods/Fabric/Fabric.framework/run $FABRIC_API_KEY $FABRIC_BUILD_SECRET"
end

project.save
EOF
