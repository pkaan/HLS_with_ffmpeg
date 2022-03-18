For live streaming with RTMP module (Real-Time Messaging Protocol)

Install nginx with rtmp mod

sudo apt install libnginx-mod-rtmp

Modify the nginx.conf and add wanted HLS configuration:

sudo nano /etc/nginx/nginx.conf

rtmp {
        server {
                listen 1935;
                chunk_size 4096;
                allow publish your_local_ip;
                deny publish all;
                
                application live {
                    	live on;
                    	record off;
                        hls on;
                        hls_path /var/www/html/stream/hls;
                        hls_fragment 6;
                        hls_playlist_length 60;

                        #dash on;
                        #dash_path /var/www/html/stream/dash;
                }
        }
}

Open the port 1935

sudo ufw allow 1935/tcp

Modify rtmp and add Access-Control-Allow-Origin:

sudo nano /etc/nginx/sites-available/rtmp

server {
    listen 8088;

    location / {
        add_header Access-Control-Allow-Origin *;
        root /var/www/html/stream;
    }
}

types {
    application/dash+xml mpd;
}

“Note: The Access-Control-Allow-Origin * header enables CORS, or

Cross-Origin Resource Sharing, which is disabled by default. This communicates to any web browsers accessing data from your server that the server may load resources from other ports or domains. 

Open port 8088

sudo ufw allow 8088/tcp

Create a directory for hls stream files

sudo mkdir /var/www/html/stream

 

FFMPEG command for rtmp, static file
ffmpeg -i #{file_path} -c:a aac -ar 44100 -f flv -flvflags no_duration_filesize rtmp://localhost/live/stream

FFMPEG command for rtmp, dynamic file

For example, the following command will take the device’s microphone (-i default) as an input and send it to rtmp, ‘alsa’ or ‘pulse’ can be used.
system "ffmpeg -f alsa -re -i default -c:v copy -vn -c:a aac -ar 44100 -ac 1 -f flv rtmp://localhost/live/stream"

To watch the stream

Stream can be found in the browser: http://your_domain:8088/hls/stream.m3u8

Stream can be also opened in vlc player:

 → open Network Stream → rtmp://localhost/live/stream

To open .m3u8 files in the browser, configure html5 with video.js player or use an extension.
 

