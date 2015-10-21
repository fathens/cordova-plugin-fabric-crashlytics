#!/usr/bin/env ruby

require 'xcodeproj'

proj = Dir.glob('*.xcodeproj')[0]
puts "Editing #{proj}"

project = Xcodeproj::Project.open proj

project.targets.each do |target|
    phase = target.new_shell_script_build_phase "Fabric"
    phase.shell_script = "./Pods/Fabric/Fabric.framework/run $FABRIC_API_KEY $FABRIC_BUILD_SECRET"
end

project.save
