#!/usr/bin/env ruby

require 'xcodeproj'

Dir.chdir Pathname('platforms').join('ios').realpath

project = Xcodeproj::Project.open(Pathname.glob('*.xcodeproj')[0])

title = 'Fabric Submission'
project.targets.each do |target|
  found = target.shell_script_build_phases.find do |phase|
    phase.name == title
  end
  if found != nil then
    puts "Already added '#{title}': #{project}"
  else
    phase = target.new_shell_script_build_phase(title)
    puts "Adding '#{phase}' to #{target}: #{project}"
    phase.shell_script = "./Pods/Fabric/run #{ENV['FABRIC_API_KEY']} #{ENV['FABRIC_BUILD_SECRET']}"
  end
end

project.save
