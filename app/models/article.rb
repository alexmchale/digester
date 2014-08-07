class Article < ActiveRecord::Base

  belongs_to :user

  before_save :create_transcript
  after_save :create_mp3

  validates :user_id, presence: true

  def mp3_ready?
    sha256.present?
  end

  def create_transcript
    # If we just have a URL, run it through the texter to get its details.
    if url.present? && (new_record? || url_changed?)
      texter = ArticleTexter.new(self)

      self.title        = texter.title
      self.author       = texter.author
      self.published_at = texter.published_at
      self.body         = texter.body
    end

    # Set some defaults if we don't know the data.
    self.title        = "Unknown Title"  if title.blank?
    self.author       = "Unknown Author" if author.blank?
    self.published_at = Time.now         if published_at.blank?
    self.body         = ""               if body.blank?

    # Build the transcript that the voice engine will read.
    self.transcript = [ title, "by", author, ",,,", body ].join(" ")
  end

  def create_mp3
    return if sha256 == Digest::SHA256.hexdigest(transcript)

    encoder = ArticleEncoder.new(self)
    return unless encoder.encode

    publisher = ArticlePublisher.new(encoder.sha256, encoder.mp3_filename)
    return unless publisher.publish

    update_attributes!({
      :mp3_duration  => encoder.duration  ,
      :mp3_mime_type => encoder.mime_type ,
      :mp3_file_size => encoder.file_size ,
      :sha256        => encoder.sha256    ,
      :mp3_url       => publisher.s3_url  ,
    })
  end

end
