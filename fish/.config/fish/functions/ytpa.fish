function ytpa --wraps='yt-dlp -o "/Users/khaled/YoutubeDownloadsSync/%(title)s.%(ext)s" -x --audio-format mp3 --audio-quality 0' --description 'alias ytpa=yt-dlp -o "/Users/khaled/YoutubeDownloadsSync/%(title)s.%(ext)s" -x --audio-format mp3 --audio-quality 0'
    yt-dlp -o "/Users/khaled/YoutubeDownloadsSync/%(title)s.%(ext)s" -x --audio-format mp3 --audio-quality 0 $argv
end
