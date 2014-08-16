class Article < ActiveRecord::Base

  belongs_to :user

  after_create -> { delay.create_transcript }

  validates :user_id, presence: true

  def mp3_ready?
    sha256.present?
  end

  def create_transcript
    # If we just have a URL, run it through the texter to get its details.
    if url.present?
      texter = ArticleTexter.new(self)

      self.title        = texter.title
      self.author       = texter.author
      self.published_at = texter.published_at
      self.body         = texter.body
    end

    # Set some defaults if we don't know the data.
    self.title        = "Unknown Title"  if title.blank?
    self.author       = ""               if author.blank?
    self.published_at = Time.now         if published_at.blank?
    self.body         = ""               if body.blank?

    # Build the transcript that the voice engine will read.
    self.transcript =
      if author.present?
        [ title, "by", author, ",,,", body ].join(" ")
      else
        [ title, ",,,", body ].join(" ")
      end

    # Persist and enqueue the job to create the MP3.
    save!
    delay(queue: :mac).create_mp3
  end

  def create_mp3
    # Don't re-encoder if the content hasn't changed.
    return if sha256 == Digest::SHA256.hexdigest(transcript)

    # Build the MP3 file.
    encoder = ArticleEncoder.new(self)
    return unless encoder.encode

    # Publish it to S3.
    publisher = ArticlePublisher.new(encoder.sha256, encoder.mp3_filename)
    return unless publisher.publish

    # Update the article with the details determined during encoding.
    update_attributes!({
      :mp3_duration  => encoder.duration  ,
      :mp3_mime_type => encoder.mime_type ,
      :mp3_file_size => encoder.file_size ,
      :mp3_url       => publisher.s3_url  ,
      :sha256        => encoder.sha256    ,
    })

    # Clean up the local files created during the encode.
    encoder.purge
  end

end
