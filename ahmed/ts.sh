#!/bin/bash
# Bash script to convert a one image with audio to video
# This script required kdialog (in a future i add support for Zenity and command line options)
# 2018 Alfonso Saavedra "Son Link"
# Script under the GPLv3 or newer license

function getPercent() {
	# Get video duration in seconds
	duration=$(ffmpeg -i "$AUDIO" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p")
	fps=1
	hours=$(echo $duration | cut -d":" -f1)
	minutes=$(echo $duration | cut -d":" -f2)
	seconds=$(echo $duration | cut -d":" -f3)
	totalsecs=$(echo "($hours*3600+$minutes*60+$seconds)" | bc)

	if [ -f /tmp/ffmpeg.log ]; then rm /tmp/ffmpeg.log; fi

	# Init convert and redirect the log to a file
	ffmpeg -loop 1 -i "$IMAGE" -i "$AUDIO" \
	-c:v libvpx -c:a libvorbis -b:a 192k -b:v 1M -vf scale=$RES -auto-alt-ref 0 \
	-r 1 -shortest -y "$SAVE" -v verbose 1> /tmp/ffmpeg.log 2>&1 &

	# Get ffmpeg Process ID
	PID=$( ps -ef | grep "ffmpeg" | grep -v "grep" | awk '{print $2}' )
	dbusRef=$(kdialog --progressbar "Covirtiendo vídeo." 100)
	qdbus $dbusRef showCancelButton true

	# While ffmpeg runs, process the log file for the current time, display percentage progress
	while ps -p $PID>/dev/null  ; do
		if [[ $(qdbus $dbusRef wasCancelled) = "true" ]] ; then
			exit 1
		fi

		currenttime=$(tail -n 1 /tmp/ffmpeg.log | awk '/time=/ { print $7 }' | cut -d= -f2)
		hours=$(echo $currenttime | cut -d":" -f1)
		minutes=$(echo $currenttime | cut -d":" -f2)
		seconds=$(echo $currenttime | cut -d":" -f3)
		processedsecs=$(echo "($hours*3600+$minutes*60+$seconds)" | bc)
  	if [[ -n "$processedsecs" ]]; then
  		PROG=$(echo "scale=3; ($processedsecs/$totalsecs)*100.0" | bc)
			qdbus $dbusRef Set "" value ${PROG%.*}
  		sleep 1
  	fi
	done
}

FORMAT=$(kdialog --radiolist "Select video format and resolution:" \
	'webm-1080' "WebM FullHD (1080)" on \
	'webm-720'	'WebM HD (720)' off \
	'web-480'		'WebM SD (480)' off\
	'mp4-1080' 	'MP4 FullHD (1080)' off \
	'mp4-720'		'MP4 HD (720)' off \
	'mp4-480'		'MP4 SD (480)' off )
if [ $? = 1 ]; then exit 1; fi
EXT=$(echo $FORMAT | cut -d- -f1)
RES=$(echo $FORMAT | cut -d- -f2)
if [ $RES = '1080' ]; then
	RES='1920:1080'
elif [ $RES = '720' ]; then
	RES='1280:720'
elif [ $RES = '480' ]; then
	RES='854:480'
fi

IMAGE=$(kdialog --getopenfilename . "Images (*.png *.jpg *.bmp)" --title 'Select image')
if [ $? = 1 ]; then exit 1; fi

AUDIO=$(kdialog --getopenfilename . "Audio (*.mp3 *.ogg *.wav *.aac *.flac *m4a)" --title 'Select audio')
if [ $? = 1 ]; then exit 1; fi

SAVE=$(kdialog --getsavefilename :video.$EXT "Video file (*.$EXT)" --title 'Set output file name')
if [ $? = 1 ]; then exit 1; fi

if [ -n "$FORMAT" ] && [ -n "$IMAGE" ] && [ -n "$AUDIO" ] && [ -n "$SAVE" ]; then
	getPercent
fi
