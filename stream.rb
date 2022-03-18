#stream.rb


# Run Nginx server with rtmp module if live streaming
# HLS can be configured in rtmp module, if wanted

# Use alsa or pulse for dynamic file, for example incoming input from microphone = default

def live_stream_for_rtmp()
    system "ffmpeg  -f alsa \
    -re -i default -c:a aac \
    -f flv -ar 44100 \ 
    -flvflags no_duration_filesize rtmp://localhost/show/stream"
end


# Run Nginx server as a file share server

# 128 kbit/s – low quality bitrate
# 192 kbit/s – medium quality bitrate
# 256 kbit/s – a commonly used high-quality bitrate
# 320 kbit/s – highest level supported by the MP3 

def build_hls_stream_files()
    file = "mozart.ogg"
    system "ffmpeg -y -i #{file} -vn \
    -map 0:0 -map 0:0 -map 0:0 -map 0:0 \
    -b:a:0 128k -b:a:1 192k -b:a:2 256k -b:a:3 320k -c:a aac \
    -var_stream_map 'a:0,name:low a:1,name:med a:2,name:high a:3,name:very_high' 
    -master_pl_name master.m3u8 -f hls -hls_time 10 -hls_playlist_type vod -hls_list_size 0 \ 
    -hls_segment_filename '%v/segment%d.aac' %v/index.m3u8"
end
