#!/bin/bash

cat > src/main/AndroidManifest.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="org.fathens.cordova.plugin.fabric" >
    <uses-sdk android:minSdkVersion="19" />
    <application>
        <activity android:name=".MainActivity" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

cat > Gemfile <<EOF
source 'https://rubygems.org'

gem "fetch_local_lib", :git => "https://github.com/fathens/fetch_local_lib.git"
gem "cordova_plugin_kotlin", :git => "https://github.com/fathens/Cordova-Plugin-Kotlin.git"
gem "cordova_plugin_fabric", :git => "https://github.com/fathens/Cordova-Plugin-Fabric.git"
EOF

bundle install && bundle update

cat > .generator.rb <<EOF
require 'pathname'
require 'cordova_plugin_kotlin'
require 'cordova_plugin_fabric'

PLATFORM_DIR = Pathname('$0').realpath.dirname
PLUGIN_DIR = PLATFORM_DIR.dirname.dirname

build_gradle = PLATFORM_DIR/'build.gradle'
write_build_gradle build_gradle
modify_gradle build_gradle, ENV['FABRIC_API_KEY'], ENV['FABRIC_BUILD_SECRET']

log "Generating project done"
log "Open by AndroidStudio. Thank you."
EOF

bundle exec ruby .generator.rb
