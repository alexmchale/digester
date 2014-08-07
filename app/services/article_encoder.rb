class ArticleEncoder

  attr_reader :article, :transcript, :sha256, :duration, :file_size, :mime_type

  def initialize(article)
    @article    = article
    @transcript = article.transcript
    @sha256     = Digest::SHA256.hexdigest(transcript)
  end

  def encode
    # Write the content to disk.
    File.open(txt_filename, "w") { |f| f.puts transcript }

    # Build the AIFF file.
    system "echo %s | say -o %s -v %s -f %s" % [
      transcript,
      aiff_filename,
      aiff_voice,
      txt_filename,
    ].map(&:to_s).map(&:shellescape)

    # Encode an MP3.
    system "lame --preset voice %s %s" % [
      aiff_filename,
      mp3_filename,
    ].map(&:to_s).map(&:shellescape)

    # Read back details about the MP3.
    TagLib::FileRef.open(mp3_filename.to_s) do |fileref|
      @mime_type = "audio/mpeg"
      @file_size = File.size(mp3_filename)
      @duration  = fileref.audio_properties.length
    end

    # Return self so we can chain.
    self
  end

  def purge
    # Remove the local files that were created during encode.
    [ txt_filename, aiff_filename, mp3_filename ].each do |filename|
      FileUtils.rm_rf filename
    end
  end

  def txt_filename
    Rails.root.join("public", "articles", "#{ sha256 }.txt")
  end

  def aiff_filename
    Rails.root.join("public", "articles", "#{ sha256 }.aiff")
  end

  def mp3_filename
    Rails.root.join("public", "articles", "#{ sha256 }.mp3")
  end

  def aiff_voice
    "Alex"
  end

end
