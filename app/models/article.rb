class Article < ActiveRecord::Base

  after_save :create_mp3

  def pismo
    @pismo ||= Pismo::Document.new(url)
  end

  def title
    pismo.title
  end

  def author
    pismo.author
  end

  def body
    pismo.body
  end

  def create_mp3
    # Write the content to disk.
    File.open(txt_filename, "w") do |f|
      f.puts "#{ title } by #{ author }"
      f.puts body
    end

    # Build the AIFF file.
    system "echo %s | say -o %s -v %s -f %s" % [
      body,
      aiff_filename,
      aiff_voice,
      txt_filename,
    ].map(&:to_s).map(&:shellescape)

    # Encode an MP3.
    system "lame --preset voice %s %s" % [
      aiff_filename,
      mp3_filename,
    ].map(&:to_s).map(&:shellescape)
  end

  def txt_filename
    Rails.root.join("public", "articles", "#{ id }.txt")
  end

  def aiff_filename
    Rails.root.join("public", "articles", "#{ id }.aiff")
  end

  def mp3_filename
    Rails.root.join("public", "articles", "#{ id }.mp3")
  end

  def aiff_voice
    "Alex"
  end

end
