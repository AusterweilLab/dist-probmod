#!/bin/bash
# Install script
echo "beginning installation..."
echo "downloading and installing formdiscovery"
mkdir ./formdiscovery1.0
curl http://www.psy.cmu.edu/~ckemp/code/formdiscovery1.0.tar.gz | tar xz -C ./formdiscovery1.0
echo "downloading and installing nauty25r9"
curl http://cs.anu.edu.au/~bdm/nauty/nauty25r9.tar.gz | tar xz -C ./nauty25r9
cd nauty25r9
./configure
make
cd ..
echo "installation finished!"
