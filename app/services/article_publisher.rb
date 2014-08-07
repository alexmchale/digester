class ArticlePublisher

  attr_reader :identifier, :mp3_filename

  def initialize(identifier, mp3_filename)
    @identifier   = identifier
    @mp3_filename = mp3_filename

    # Ensure we were given an identifier
    unless identifier.present?
      raise(PublicationError, "no identifier was specified for a publishable file")
    end
  end

  def publish
    # Verify that the MP3 file exists.
    if !local_mp3_exists?
      raise(PublicationError, "cannot find local mp3 for #{ identifier.inspect }")
    end

    # Push the MP3 file up to S3, if it's not already there.
    if !s3_mp3_exists? && !upload_to_s3
      raise(PublicationError, "failed to upload mp3 to s3")
    end

    # Success!
    return self
  end

  def s3_filename
    "#{ identifier }.mp3"
  end

  def s3_url
    $s3.files.head(s3_filename).public_url
  end

  def local_mp3_exists?
    return false unless File.exists?(mp3_filename)
    return false unless File.file?(mp3_filename)
    return false unless File.readable?(mp3_filename)
    return false unless File.size(mp3_filename) > 0
    return true
  end

  def s3_mp3_exists?
    $s3.files.head(s3_filename) != nil
  end

  def upload_to_s3
    $s3.files.create({
      :key          => s3_filename             ,
      :content_type => "audio/mpeg"            ,
      :body         => File.open(mp3_filename) ,
      :public       => true                    ,
    })
  end

  class PublicationError < RuntimeError ; end

end
