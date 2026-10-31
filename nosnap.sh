#!/bin/sh
echo 'Removing ALL snaps'
sudo snap remove $(snap list | awk '!/^Name|^core|^snapd/ {print $1}') 2>/dev/null || true
sudo apt purge --autoremove snapd
echo 'Adding Mozilla Firefox and Thunderbird Official Repo...'
sudo apt install wget -y
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla thunderbird-deb
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF 

echo 'Configuring APT Pinning...'
sudo cat <<EOF > /etc/apt/preferences.d/nosnap
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1001

Package: firefox
Pin: release o=Ubuntu
Pin-Priority: -1

Package: thunderbird
Pin: release o=Ubuntu
Pin-Priority: -1

Package: chromium-browser
Pin: release o=Ubuntu
Pin-Priority: -1

Package: snapd
Pin: release o=Ubuntu
Pin-Priority: -1
EOF

echo 'Done'
