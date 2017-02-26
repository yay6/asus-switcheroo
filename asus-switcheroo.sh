#!/bin/sh

case "$1" in
	pre)
		if [ -e /sys/kernel/debug/vgaswitcheroo/switch ]; then
			echo ON > /sys/kernel/debug/vgaswitcheroo/switch
		fi
    	;;
	post)
		if [ -e /sys/kernel/debug/vgaswitcheroo/switch ]; then
    		echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
    	fi
    	;;
esac
