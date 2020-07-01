#!/bin/bash

cat >  ~/.local/share/applications/nothing-extenstion-nothing.desktop << EOF
[Desktop Entry]
Type=Application
Name=Nothing Scheme Handler
Exec=/home/steve/projects/scripts/ssh.bash %u
StartupNotify=false
MimeType=x-scheme-handler/nothing;
EOF

echo 'x-scheme-handler/nothing=nothing-extenstion-nothing.desktop;' >> ~/.local/share/applications/mimeinfo.cache










