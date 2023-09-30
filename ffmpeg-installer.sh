#!/bin/bash
​
if [ "$UID" -ne 0 ]
  then echo "I need to be root.."
  exit
fi
​
programs=("git" "nasm" "yasm" "gcc" "gettext" "patch" "autoconf" "automake")
libs=("build-essential" "libvorbis-dev" "libxvidcore-dev"  "libfaad2"  "libtheora-dev" "libdirac-dev" "libvdpau-dev" "libopenjpeg-dev" "libopencore-amrwb-dev" "libopencore-amrnb-dev" "libgsm1-dev" "libschroedinger-dev" "libspeex-dev" "libdc1394-22-dev" "libsdl1.2-dev" "libx11-dev" "libxfixes-dev" "libvo-aacenc-dev" "libssl-dev" "libgd-dev" "libfreetype6" "libfreetype6-dev" "libpng-dev" "libtiff-dev libtool libxml2 libxml2-dev libncurses-dev ncurses-dev libmp3lame-dev mediainfo")
​
for i in ${programs[*]}
do
    type $i >/dev/null 2>&1
    if [ $? -eq 1 ]; then
        echo -n $i" is not installed.. Installing.."
        apt-get install -y $i >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo " OK"
        else
            echo " FAIL"
        fi
    fi 
done
​
for i in ${libs[*]}
do
    dpkg -s $i >/dev/null 2>&1
    if [ $? -eq 1 ]; then
        echo -n $i" is not installed.. Installing.."
        apt-get install -y $i >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo " OK"
        else
            echo " FAIL"
        fi
    fi 
done
​
echo -n "git clone of ffmpeg... "
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg 
cd ffmpeg 

wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
​
tar xf yasm-1.3.0.tar.gz
cd yasm-1.3.0 && ./configure && make && make install && cd ..
​
git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx && ./configure && make && make install && cd ..
​
git clone git://git.videolan.org/x264.git
cd x264
./configure --enable-static --enable-shared --disable-lavf
make
make install
ldconfig
cd .. 

./configure --enable-static --disable-shared --disable-ffserver --disable-doc --enable-bzlib --enable-zlib --enable-postproc --enable-runtime-cpudetect --enable-libx264 --enable-gpl --enable-libtheora --enable-libvorbis --enable-libmp3lame --enable-gray --enable-libopenjpeg --enable-libspeex --enable-version3 --enable-libvpx --enable-nonfree
make clean
make


