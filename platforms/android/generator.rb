#!/bin/bash

cat > Gemfile <<EOF
source 'https://rubygems.org'

gem "fetch_local_lib", :git => "https://github.com/fathens/fetch_local_lib.git"
gem "cordova_plugin_kotlin", :git => "https://github.com/fathens/Cordova-Plugin-Kotlin.git"
gem "cordova_plugin_fabric", :git => "https://github.com/fathens/Cordova-Plugin-Fabric.git"
EOF

bundle install && bundle update

bundle exec ruby <<EOF
require 'pathname'
require 'cordova_plugin_kotlin'
require 'cordova_plugin_fabric'

PLATFORM_DIR = Pathname('$0').realpath.dirname

Kotlin::mk_skeleton PLATFORM_DIR
Fabric::modify_gradle PLATFORM_DIR/'build.gradle', ENV['FABRIC_API_KEY'], ENV['FABRIC_BUILD_SECRET']

log "Generating project done"
log "Open by AndroidStudio. Thank you."
EOF
