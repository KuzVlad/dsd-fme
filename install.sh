#! /bin/bash
clear
echo DSD-FME Digital Speech Decoder - Florida Man Edition Auto Installer
echo MBELib is considered a requirement on this build.
echo You must view this notice prior to continuing. 
echo The Patent Notice can be found at the site below.
echo https://github.com/szechyjs/mbelib#readme
echo Please confirm that you have viewed the patent notice by entering y below.
echo
echo y/N
read ANSWER
Y='y'
if [[ $Y == $ANSWER ]]; then

sudo apt update
sudo apt install libsndfile1-dev libfftw3-dev liblapack-dev socat libusb-1.0-0-dev libncurses5 libncurses5-dev rtl-sdr librtlsdr-dev libusb-1.0-0-dev cmake git wget make build-essential


wget -O itpp-latest.tar.bz2 http://sourceforge.net/projects/itpp/files/latest/download?source=files
tar xjf itpp*
#if you can't cd into this folder, double check folder name first
cd itpp-4.3.1 
mkdir build
cd build
cmake ..
make -j `nproc`
sudo make install
sudo ldconfig
cd ..
cd ..

git clone https://github.com/szechyjs/mbelib
cd mbelib
mkdir build
cd build
cmake ..
make -j `nproc`
sudo make install
sudo ldconfig
cd ..
cd ..

git clone https://github.com/lwvmobile/dsd-fme
cd dsd-fme
mkdir build
cd build
cmake ..
make -j `nproc`
##only run make install if you don't have another version already installed##
sudo make install
sudo ldconfig

else
echo
echo Sorry, you cannot build DSD-FME without acknowledging the Patent Notice.
fi



