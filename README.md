# youtube-dl gem

This is a youtube-dl video downloader wrapper.

## Usage
    >> youtube = YoutubeDl::YoutubeVideo.new("http://www.youtube.com/watch?v=zzG4K2m_j5U")
    >> video = youtube.download_video
    => "tmp/downloads/zzG4K2m_j5U.mp4"
    >> preview = youtube.download_preview
    => "tmp/downloads/zzG4K2m_j5U.jpg"

## Changelog

### 0.0.2
Update youtube-dl script to last binary version. This update fixed download from youtube error.

### 0.0.1
Initial release.