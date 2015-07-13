#!/bin/bash
# Install script
echo "beginning installation..."
echo "downloading and installing formdiscovery"
mkdir ./formdiscovery1.0
cd ./formdiscovery1.0/
wget http://charleskemp.com/code/formdiscovery1.0.tar.gz
tar xvzf formdiscovery1.0.tar.gz
rm formdiscovery1.0.tar.gz
cd ..
echo "downloading and installing nauty25r9"
wget http://cs.anu.edu.au/~bdm/nauty/nauty25r9.tar.gz
tar xvzf nauty25r9.tar.gz
rm nauty25r9.tar.gz
cd nauty25r9
./configure
make
cd ..
echo "installation finished!"
