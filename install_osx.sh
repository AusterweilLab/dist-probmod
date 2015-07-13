#!/bin/bash
# Install script
echo "beginning installation..."
echo "downloading and installing formdiscovery"
curl http://charleskemp.com/code/formdiscovery1.0.tar.gz | tar xz
echo "downloading and installing nauty25r9"
curl http://cs.anu.edu.au/~bdm/nauty/nauty25r9.tar.gz | tar xz
cd nauty25r9
./configure
make
cd ..
echo "installation finished!"
