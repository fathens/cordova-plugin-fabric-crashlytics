#!/bin/bash
set -eu

echo "################################"
echo "#### Fabric API_KEY"

fix_newlines() {
    file="$1"
    tmp="${file}.tmp"
    cat "$file" | awk '{print $0}' > "$tmp"
    echo "$tmp"
}

insert() {
    file="$1"
    tmp="${file}.tmp"
    
    head -n$(($(wc -l "$file" | awk '{print $1}') - 2)) "$file" > "$tmp"
    cat <<EOF >> "$tmp"
<key>Fabric</key>
<dict>
    <key>APIKey</key>
    <string>$FABRIC_API_KEY</string>
    <key>Kits</key>
    <array>
        <dict>
            <key>KitInfo</key>
            <dict/>
            <key>KitName</key>
            <string>Crashlytics</string>
        </dict>
    </array>
</dict>
EOF
    tail -n2 "$file" >> "$tmp"
    echo "$tmp"
}

file="$(find . -name '*-Info.plist')"
echo "Edit $(pwd)/$file"

tmp="$(fix_newlines "$file")"
result="$(insert "$tmp")"
rm -f "$tmp"

diff "$file" "$result" | sed 's/\(^>     <string>\).*\(<\/string>\)/\1...\2/' || mv -f "$result" "$file"
