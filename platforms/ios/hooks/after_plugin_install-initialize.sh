#!/bin/bash
set -eu

echo "################################"
echo "#### Fabric initialization"

file="$(find . -name 'AppDelegate.m')"
echo "Edit $(pwd)/$file"

cat "$file" | awk '
	/didFinishLaunchingWithOptions/ { did=1 }
	/return/ && (did == 1) {
		print "    [Fabric with:@[CrashlyticsKit]];"
		did=0
	}
	{ print $0 }
	/#import </ {
		print "#import <Fabric/Fabric.h>"
		print "#import <Crashlytics/Crashlytics.h>"
	}
' > "${file}.tmp"

diff "$file" "${file}.tmp" || mv -f "${file}.tmp" "$file"
