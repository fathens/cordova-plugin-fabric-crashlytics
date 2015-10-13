#!/bin/bash

cd "$(dirname $0)"

echo "################################"
echo "#### Generate Xcodeproject"

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

project_name = "Cordova-Plugin-Crashlytics"
project = Xcodeproj::Project.new "#{project_name}.xcodeproj"

target = project.new_target(:framework, 'GeneratedProduct', :ios)
project.recreate_user_schemes

sources = []
sources << project.main_group.new_reference("src/FabricAnswers.swift")
sources << project.main_group.new_reference("src/FabricCrashlytics.swift")
project.main_group.new_reference("src/fabric-Bridging-Header.h")

target.add_file_references(sources)

build_settings(project,
  "ENABLE_BITCODE" => "NO",
  "SWIFT_OBJC_BRIDGING_HEADER" => "src/fabric-Bridging-Header.h"
)

project.save
EOF

echo "################################"
echo "#### pod install"

cat <<EOF > Podfile
platform :ios, "8.0"

pod "Cordova"
pod "Fabric"
pod "Crashlytics"
EOF

pod install
