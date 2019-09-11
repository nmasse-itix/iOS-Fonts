#!/bin/bash

function add_font() {
  echo "Adding $1 to the mobileconfig..."

  cat >> ios-fonts.mobileconfig <<EOF
<dict>
<key>Name</key>
<string>$i</string>
<key>PayloadIdentifier</key>
<string>$(uuidgen)</string>
<key>PayloadType</key>
<string>com.apple.font</string>
<key>PayloadUUID</key>
<string>$(uuidgen)</string>
<key>PayloadVersion</key>
<integer>1</integer>
<key>Font</key>
<data>
$(openssl base64 -in "$1")
</data>
</dict>
EOF
}

cat > ios-fonts.mobileconfig <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>PayloadDisplayName</key>
<string>iOS Custom Fonts - $(date)</string>
<key>PayloadIdentifier</key>
<string>fr.itix.ios-fonts.$(uuidgen)</string>
<key>PayloadRemovalDisallowed</key>
<false/>
<key>PayloadType</key>
<string>Configuration</string>
<key>PayloadUUID</key>
<string>$(uuidgen)</string>
<key>PayloadVersion</key>
<integer>1</integer>
<key>PayloadContent</key>
<array>
EOF

if [ $# -gt 0 ]; then
  for i; do 
    add_font "$i"
  done
else
  for i in ~/Library/Fonts/*.?tf; do 
    add_font "$i"
  done
fi

cat >> ios-fonts.mobileconfig <<EOF
</array>
</dict>
</plist>
EOF


