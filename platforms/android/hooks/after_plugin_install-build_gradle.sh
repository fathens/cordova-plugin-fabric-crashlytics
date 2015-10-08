#!/bin/bash
set -eu

echo "################################"
echo "#### Edit build.gradle"

file=build.gradle

cat "$file" | awk '
    /classpath '\''com\.android\.tools\.build:gradle:1\.0\.0\+'\''/ {
        sub("1\.0\.0", "1.1.0")
        print $0
        sub("[^ ].*", "classpath '\''io.fabric.tools:gradle:1.+'\''")
        print $0
        sub("[^ ].*", "classpath '\''org.jetbrains.kotlin:kotlin-gradle-plugin:0.14.449'\''")
    }
    { print $0 }
    compile == 1 {
        sub("[^ ].*", "compile('\''com.crashlytics.sdk.android:crashlytics:2.5.2@aar'\'') { transitive = true }")
        print $0
        sub("[^ ].*", "compile '\''org.jetbrains.kotlin:kotlin-stdlib:0.14.449'\''")
        print $0
        compile=0
    }
    /apply plugin:/ {
        sub("[^ ].*", "apply plugin: '\''io.fabric'\''")
        print $0
        sub("[^ ].*", "apply plugin: '\''kotlin-android'\''")
        print $0
    }
    /mavenCentral/ {
        sub("[^ ].*", "maven { url '\''https://maven.fabric.io/public'\'' }")
        print $0
    }
    /java\.srcDirs/ {
        sub("[^ ].*", "kotlin.srcDirs = ['\''kotlin'\'']")
        print $0
    }
    /^dependencies / {
        compile=1
    }
' > "${file}.tmp"
mv -vf "${file}.tmp" "$file"
