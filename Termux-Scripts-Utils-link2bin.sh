#!/data/data/com.termux/files/usr/bin/bash
if [ -n "$PREFIX" ] && [ -d "$PREFIX" ]; then
	mypath="$( realpath "${BASH_SOURCE[0]}" )"
	if [ ! -f "$mypath" ]; then
	        mypath="$( realpath "$0" )"
	fi
	if [ -f "$mypath" ]; then
		mydir="$(dirname "$mypath")"
		ln -s "${mydir}/*" "$PREFIX/bin/"
	fi
fi
