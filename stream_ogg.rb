def stream_ogg
    system "ffmpeg -re -i 'mozart.ogg' -c:v copy -vn -c:a aac -ar 44100 -ac 1 -f flv rtmp://localhost/live/stream"
    
end

stream_ogg()