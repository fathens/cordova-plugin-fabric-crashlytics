#!/usr/bin/env ruby

require 'xcodeproj'

Dir.chdir Pathname('platforms').join('ios').realpath

project = Xcodeproj::Project.open(Pathname.glob('*.xcodeproj')[0])

project.targets.each do |target|
  phase = target.new_shell_script_build_phase('Fabric')
  phase.shell_script = "./Pods/Fabric/Fabric.framework/run #{ENV['FABRIC_API_KEY']} #{ENV['FABRIC_BUILD_SECRET']}"
end

project.save
