#!/bin/bash
set -eu

find src -name 'MainActivity.java' | while read file
do
	cat "$file" | awk '
		{print $0}
		/super.onCreate/ {
			sub("super.*", "io.fabric.sdk.android.Fabric.with(this, new com.crashlytics.android.Crashlytics());");
			print $0
		}
	' > "${file}.tmp"
	mv -vf "${file}.tmp" "$file"
done
