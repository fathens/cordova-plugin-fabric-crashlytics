#!/bin/bash
set -eu

echo "################################"
echo "#### Fabric initialization"

find src -name 'MainActivity.java' | while read file
do
    echo "Edit $(pwd)/$file"
	cat "$file" | awk '
		{print $0}
		/super.onCreate/ {
			sub("super.*", "io.fabric.sdk.android.Fabric.with(this, new com.crashlytics.android.Crashlytics());");
			print $0
		}
	' > "${file}.tmp"
	
	diff "$file" "${file}.tmp" || mv -f "${file}.tmp" "$file"
done
