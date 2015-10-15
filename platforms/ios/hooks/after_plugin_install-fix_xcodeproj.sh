#!/bin/bash
set -eu

plugin_id=$1

echo "################################"
echo "#### Fix project.pbxproj"

proj="$(find . -maxdepth 1 -name '*.xcodeproj')"
echo "Fixing $(pwd)/$proj"

project_name="$(basename "${proj%%.xcodeproj}")"

cat <<EOF | ruby
require 'xcodeproj'

def build_settings(project, params)
    project.targets.each do |target|
        target.build_configurations.each do |conf|
            params.each do |key, value|
                conf.build_settings[key] = value
            end
        end
    end
end

project = Xcodeproj::Project.open "$proj"

build_settings(project,
    "LD_RUNPATH_SEARCH_PATHS" => "\$(inherited) @executable_path/Frameworks",
    "SWIFT_OBJC_BRIDGING_HEADER" => "${project_name}/Plugins/${plugin_id}/fabric-Bridging-Header.h"
)

project.targets.each do |target|
    phase = target.new_shell_script_build_phase "Fabric"
    phase.shell_script = "./Pods/Fabric/Fabric.framework/run $FABRIC_API_KEY $FABRIC_BUILD_SECRET"
end

project.save
EOF
