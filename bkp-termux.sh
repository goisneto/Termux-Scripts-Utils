#!/data/data/com.termux/files/usr/bin/bash
cd ..
tar -cvzf /sdcard/termux-usr.tar.gz ./usr
tar -cvzf /sdcard/termux-home.tar.gz --exclude="./home/support/1/*" ./home
