#!/usr/bin/bash

# Website	Group		Once	Limit	Update     Size	Duration FPS Format															Resolution	VBitrate	ARate	ABitrate	Thumbnail
# 163.com	163		 	 	2023-01-07 5GB	           avi,mov,wmv														 		 		 	 		 
# 56.com	default		 	 	2023-01-07  	            																 		 		 	 		 
# bilibili.com	bilibili	 	 	2023-01-07 8GB	10:00:00    avi,wmv,mov,webm,mpeg4,ts,mpg,rm,rmvb,mkv,m4v										8192*4320	50000kbps	48KHz	320kbps		 
# douyin.com	douyin		 	 	2023-01-07 8GB	00:30:00     																 		 		 	 		 
# douyu.com	douyu		30	 	2023-01-07 20GB	           wmv,asf,rm,rmvb,mpg,mpeg,3gp,mov,webm,mkv,avi										 		 		 	 		 
# huya.com	default		 	 	2023-01-07  	            																 		 		 	 		 
# iqiyi.com	iqiyi		5	30	2023-01-07 8GB	           wmv,wm,asf,rm,rmvb,ra,ram,mpg,mpeg,mpe,vob,dat,mov,3gp,m4v,mkv,avi,fly,fv4							 		 		 	 		10MB
# ixigua.com	default		 	 	2023-01-07 64GB	03:00:00     																 		 		 	 		 
# qq.com	qq		 	 	2023-01-07 40GB	01:00:00    f4v,webmm4v,mov,3gp,3g2rm,rmvbwmv,avi,asfmpg,mpeg,mpe,tsdiv,dv,divxvob,dat,mkv,swf,lavf,cpk,dirac,ram,qt,fli,flc,mod	 		 		 	 		 
# youku.com	youku		 	 	2023-01-07 10GB	            																 		 		 	 		 

# Group		Size	Duration FPS	Format	Resolution	VBitrate	ARate	ABitrate	Thumbnail
# default	64GB	10:00:00 60	avi	8192*4320	1864.1kbps	48KHz	320kbps		 
# 163		5GB	10:00:00 60	avi	8192*4320	145.64kbps	48KHz	320kbps		 
# bilibili	8GB	10:00:00 60	avi	8192*4320	233.2kbps	48KHz	320kbps		 
# douyin	8GB	00:30:00 60	avi	8192*4320	4660.3kbps	48KHz	320kbps		 
# douyu		20GB	10:00:00 60	avi	8192*4320	582.54kbps	48KHz	320kbps		 
# iqiyi		8GB	10:00:00 60	avi	8192*4320	233.2kbps	48KHz	320kbps		10MB	
# qq		40GB	01:00:00 60	avi	8192*4320	11651kbps	48KHz	320kbps		 

# ffmpeg -decoders|grep qsv

mkdir tmp

mkdir default
mkdir 163
mkdir bilibili
mkdir douyin
mkdir douyu
mkdir iqiyi
mkdir qq

raw_fps=(ffprobe $1) | sed -n 's/\(\d+\) fps/\1/p'
multiply=(echo "scale=2 ; 60 / $raw_fps") | bc
echo $multiply

ffmpeg -hide_banner -hwaccel qsv -c:v h264_qsv -i $1 -vcodec copy tmp/raw.h264 -vn -acodec copy tmp/raw.aac

#ffmpeg -hwaccel qsv -c:v h264_qsv -i input.mp4 -codec:copy

#rm -rf tmp
#rm $1
