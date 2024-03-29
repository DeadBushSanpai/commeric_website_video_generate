#!/usr/bin/bash

# Website	Group		Once	Limit	Update     Size	Duration FPS Format															Resolution	VBitrate	ARate	ABitrate	Thumbnail	ThumbnailSize
# 163.com	163		 	 	2023-01-07 5G	           avi,mov,wmv														 		 		 	 		 
# 56.com	default		 	 	2023-01-07  	            																 		 		 	 		 
# bilibili.com	bilibili	 	 	2023-01-07 8G	10:00:00    avi,wmv,mov,webm,mpeg4,ts,mpg,rm,rmvb,mkv,m4v										8192*4320	50000kbps	48KHz	320kbps		5MB		960x600+
# douyin.com	douyin		 	 	2023-01-07 8G	00:30:00     																 		 		 	 		 
# douyu.com	douyu		30	 	2023-01-07 20G	           wmv,asf,rm,rmvb,mpg,mpeg,3gp,mov,webm,mkv,avi										 		 		 	 		 
# huya.com	default		 	 	2023-01-07 500M	            																 		 		 	 		 
# iqiyi.com	iqiyi		5	30	2023-01-07 8G	           wmv,wm,asf,rm,rmvb,ra,ram,mpg,mpeg,mpe,vob,dat,mov,3gp,m4v,mkv,avi,fly,fv4							 		 		 	 		10MB
# ixigua.com	default		 	 	2023-01-07 64G	03:00:00     																 		 		 	 		 
# qq.com	qq		 	 	2023-01-07 40G	01:00:00    f4v,webmm4v,mov,3gp,3g2rm,rmvbwmv,avi,asfmpg,mpeg,mpe,tsdiv,dv,divxvob,dat,mkv,swf,lavf,cpk,dirac,ram,qt,fli,flc,mod	 		 		 	 		 
# youku.com	youku		 	 	2023-01-07 10G	            																 		 		 	 		 

# Group		Size	Duration FPS	Format	Resolution	VBitrate	ARate	ABitrate	Thumbnail
# default	64GB	10:00:00 60	avi	8192*4320	1864.1kbps	48KHz	320kbps		 
# 163		5GB	10:00:00 60	avi	8192*4320	145.64kbps	48KHz	320kbps		 
# bilibili	8GB	10:00:00 60	avi	8192*4320	233.2kbps	48KHz	320kbps		5MB
# douyin	8GB	00:30:00 60	avi	8192*4320	4660.3kbps	48KHz	320kbps		 
# douyu		20GB	10:00:00 60	avi	8192*4320	582.54kbps	48KHz	320kbps		 
# iqiyi		8GB	10:00:00 60	avi	8192*4320	233.2kbps	48KHz	320kbps		10MB	
# qq		40GB	01:00:00 60	avi	8192*4320	11651kbps	48KHz	320kbps		 

mkdir tmp

#mkdir default
#mkdir 163
#mkdir bilibili
#mkdir douyin
#mkdir douyu
#mkdir iqiyi
#mkdir qq

echo $1
raw_fps=$(ffprobe "$1" |& grep -oP '\d*\d(?= fps)')
echo "raw_fps=$raw_fps"

multiply=$(awk -v fps=60 -v raw_fps=$raw_fps 'BEGIN { print  ( fps / raw_fps ) }')

echo "multiply=$multiply"

fileformat=${1##*.}
filename=${1%.$fileformat}
echo "filename=$filename"
echo $filename.$fileformat

ffmpeg -hide_banner -i "$filename.$fileformat" -map 0:v -c:v copy -bsf:v h264_mp4toannexb "tmp/$filename.h264" -map 0:a -c:a copy -vn "tmp/$filename.aac"

ffmpeg -hide_banner -fflags +genpts -r 60 -i "tmp/$filename.h264" -i "tmp/$filename.aac" -map 0:v -c:v copy -map 1:a -af "atempo=2, atempo=2, atempo=1.875" "tmp/speedup$filename.mp4" && (rm "tmp/$filename.h264" "tmp/$filename.aac" && echo "\t h264 file Removed")

#-movflags faststart 

ffmpeg -hide_banner -i "tmp/speedup$filename.mp4" -sws_flags lanczos -tune animation -q:v 233.3k -q:a 320k -c:a copy "result$filename.avi"

ffmpeg -hide_banner -ss 60 -i "$filename.$fileformat" -vframes 1 -s 8192x4320 -f image2 -y "thumbnail$filename.png"

mv "$1" tmp/ 

#ffmpeg -ss 5 -i sample.mp4 -vframes 1 -s 320x240 -f image2 -y sample.jpg
#rm -rf tmp
#rm $1

