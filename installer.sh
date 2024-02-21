#! /bin/bash
BaseURL="https://pkg.cloudflareclient.com/"
FileURL=$(curl -s https://pkg.cloudflareclient.com/dists/focal/main/binary-amd64/Packages | grep Filename | cut -d ' ' -f 2)
FILENAME=$(echo $FileURL | cut -d '/' -f 6)
echo "Latest version: $FILENAME"
echo "Downloading..."
sh -c "$(curl -LO $BaseURL$FileURL)"

echo "turning on -x for visibility"
set -x
mkdir working
mv $FILENAME "./working/"
cd working
ar x $FILENAME
tar -x --gunzip -f data.tar.gz
sudo cp -f ./bin/* /bin/
sudo cp -f ./lib/systemd/system/warp-svc.service /lib/systemd/system/
cd ..
rm -rf working
sudo systemctl daemon-reload
echo "turning off -x"
set +x
sudo systemctl status warp-svc.service --no-pager
echo "DONE!"
echo "run 'sudo systemctl enable --now warp-svc.service' if you wanna auto start"