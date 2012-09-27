require 'rubygems'
require 'httparty'
require 'uri'
require 'cgi'

module YoutubeDl
  class YoutubeVideo
    YOUTUBE_DL = File.join(File.expand_path(File.dirname(__FILE__)), "../bin/youtube-dl")

    FORMATS = {18 => {ext: "mp4"}}

    def initialize(page_uri, options = {})
      @uri = URI.parse page_uri
      @location = options[:location] || "tmp/downloads" # default path
      @format = options[:format] || 18                  # default format
    end

    def video_id
      params(@uri.query)['v'].first
    end

    def title
      extended_info_body['title'].first if extended_info.code == 200
    end

    def extended_info
      @video_info ||= HTTParty.get("http://www.youtube.com/get_video_info?video_id=#{video_id}&el=detailpage")
    end

    def download_video(options = {})
      `#{YOUTUBE_DL} -q --no-progress -o "#{video_filename}" -f #{options[:format] || @format} "#{@uri.to_s}"`
      video_filename if File.exist?(video_filename)
    end

    def download_preview(options = {})
      link = if !extended_info_body["iurlsd"].blank?
        extended_info_body["iurlsd"].first
      else
        extended_info_body["thumbnail_url"].first
      end
      `wget -O "#{preview_filename}" "#{link}"`
      preview_filename if File.exist?(preview_filename)
    end

    def preview_filename
      File.join(@location, "#{video_id}.jpg")
    end

    def video_filename
      File.join(@location, "#{video_id}.#{FORMATS[@format][:ext]}")
    end

    def extended_info_body
      params(extended_info.body)
    end

    private

    def params(body)
      CGI.parse(body)
    end
  end
end