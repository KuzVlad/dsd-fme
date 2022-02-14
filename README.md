# Digital Speech Decoder - Florida Man Edition
This version of DSD is a flavor blend of [szechyjs](https://github.com/szechyjs/dsd "szechyjs") RTL branch and some of my own additions, along with a few tweaks from the [LouisErigHerve](https://github.com/LouisErigHerve/dsd "LouisErigHerve") branch as well. NXDN voice decoding is currently working a lot better, thanks to the latter, although I have yet to explore the expanded NXDN or DMR decoding he has laid out. That is a goal. I have also implemented a few more RTL options, including rtl device gain, PPM error, device index selection, squelch, VFO bandwidth, and a UDP remote that works like the old rtl_udp fork, although its currently limited to changing frequency and squelch. The goal is to integrate this project into [EDACS-FM](https://github.com/lwvmobile/edacs-fm "EDACS-FM") but I also want it to be its own standalone project. 

![DSD-FME](https://github.com/lwvmobile/dsd-fme/blob/master/dsd-fme.png)

## Example Usage
`padsp -m dsdfme -- dsd -fi -i rtl -o /dev/dsp -c 154.9875M -P -2 -D 0 -G 46 -L 70 -U 6021 -Y 12`

```
-i rtl to use rtl_fm 

-c Set frequency

-P set PPM error

-D set device index number

-G set device gain (0-49) (default = 0 Auto Gain)

-L set rtl squelch to 70

-V set RTL sample 'volume' multiplier

-U set UDP port for rtl_fm remote control

-Y 12 set rtl VFO bandwidth in kHz, (default = 48)(6, 8, 12, 16, 24, 48)

-W Monitor Source Audio (WIP!) (may or may not decode audio if this is on, depending on selected decode type and luck)
(Also, should be noted that depending on modulation, may sound extremely terrible)
```
## Cygwin RTL Usage, output to /dev/dsp
`dsd -fi -i rtl -o /dev/dsp -c 154.9875M -P -2 -D 1 -G 36 -L 70 -U 6021 -Y 12`

## Example STDIN UDP from GQRX or SDR++, output to /dev/dsp
`socat stdio udp-listen:7355 | padsp -- dsd -fa -i - -o /dev/dsp `

## Example PA input, OSS output, save mbe files
Create MBE folder first in directory

`padsp -- dsd -fa -i pa:1 -o /dev/dsp -d ./MBE/`

## Roadmap
The Current list of objectives include:

1. Random Tinkering

2. Implement Pulse Audio and Remove PortAudio and OSS

3. Improve NXDN support 

4. More Concise Printouts - Ncurses

4. Improve Monitor Source Audio (if #2 on list is up and working)

## How to clone, check out, and build this branch
### Debian/Ubuntu
Using the included install.sh should make for a simple and painless clone, build, and install on any Debian or Ubuntu based system. Simply acquire or copy the script, and run it.

```
wget https://raw.githubusercontent.com/lwvmobile/dsd-fme/master/install.sh
chmod +x install.sh
./install.sh
```
### Cygwin
This script will attempt to automatically build and install in Cygwin environments, but the user will be responsible for installing all dependencies, including librtlsdr. 

```
wget https://raw.githubusercontent.com/lwvmobile/dsd-fme/master/cygwin_install.sh
chmod +x install.sh
./install.sh
```
### Manual Build

Or you can elect to manually follow the steps down below.

First, install dependency packages. This guide will assume you are using Debian/Ubuntu based distros. Check your package manager for equivalent packages if different. PortAudio is not currently used in this build, and is disabled in CMakeLists.txt, you can re-enable it if you wish, but it isn't recommended unless you have a very specific reason to do so. Some of these dependencies are not currently be used, but may be used in future builds.

```
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
```

MBELib is considered a requirement in this build. You must read this notice prior to continuing. [MBElib Patent Notice](https://github.com/szechyjs/mbelib#readme "MBElib Patent Notice") This version of MBELib is 1.3.0 for this main build.

```
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
```

Finish by running these steps to clone and build DSD-FME.

```
git clone https://github.com/lwvmobile/dsd-fme
cd dsd-fme
mkdir build
cd build
cmake ..
make -j `nproc`
##only run make install if you don't have another version already installed##
sudo make install
sudo ldconfig

```
Optional 'Virtual Sinks' for routing audio from SDR++ or GQRX, etc, into DSD-FME

You may wish to direct sound into DSD-FME via Virtual Sinks. You may set up a Virtual Sink or two on your machine for routing audio in and out of applications to other applications using the following command, and opening up pavucontrol "PulseAudio Volume Control" in the menu to change line out of application to virtual sink, and line in of DSD-FME to monitor of virtual sink. This command will not persist past a reboot, so you will need to invoke them each time you reboot, or search for how to add this to your conf files for persistency if desired.

```
pacmd load-module module-null-sink sink_name=virtual_sink  sink_properties=device.description=Virtual_Sink
pacmd load-module module-null-sink sink_name=virtual_sink2  sink_properties=device.description=Virtual_Sink2
```

Already have this branch, and just want to pull the latest build?

```
##Open your clone folder##
git pull
##cd into your build folder##
cd build
##cmake usually isn't necesary, but could be if I update the cmakelist.txt
cmake ..
make -j `nproc`
sudo make install
sudo ldconfig
```

## License
Copyright (C) 2010 DSD Author
GPG Key ID: 0x3F1D7FD0 (74EF 430D F7F2 0A48 FCE6  F630 FAA2 635D 3F1D 7FD0)

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
    REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
    INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
    LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
    OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
