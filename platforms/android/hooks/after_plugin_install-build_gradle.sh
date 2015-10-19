#!/bin/bash
set -eu

echo "################################"
echo "#### Edit build.gradle"

file=build.gradle
echo "Edit $(pwd)/$file"
[ -f "$file" ] || exit 1

cat "$file" | awk '
    { print $0 }
    compile == 1 {
        sub("[^ ].*", "compile('\''com.crashlytics.sdk.android:crashlytics:2.5.2@aar'\'') { transitive = true }")
        print $0
        compile=0
    }
    /classpath '\''com\.android\.tools\.build:gradle:1\.[1-9]\.0\+'\''/ && classpath == 0 {
        sub("[^ ].*", "classpath '\''io.fabric.tools:gradle:1.+'\''")
        print $0
        classpath = 1
    }
    /apply plugin:/ && plugin == 0 {
        sub("[^ ].*", "apply plugin: '\''io.fabric'\''")
        print $0
        plugin = 1
    }
    /mavenCentral/ {
        sub("[^ ].*", "maven { url '\''https://maven.fabric.io/public'\'' }")
        print $0
    }
    /^dependencies / {
        compile=1
    }
' > "${file}.tmp"

diff "$file" "${file}.tmp" || mv -f "${file}.tmp" "$file"
