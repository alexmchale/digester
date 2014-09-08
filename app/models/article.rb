class Article < ActiveRecord::Base

  ### Modules ###

  ### Constants ###

  ### Relations ###

  belongs_to :user

  ### Scopes ###

  scope :mp3_published, -> { where("mp3_url is not null") }

  ### Validations ###

  validates :user_id, presence: true

  ### Callbacks ###

  before_validation -> {
    self.raw_html.scrub! if self.raw_html
  }

  after_create -> { delay.create_transcript }

  ### Miscellaneous ###

  acts_as_paranoid

  ### Instance Methods ###

  def mp3_ready?
    sha256.present?
  end

  def create_transcript
    # If we just have a URL, run it through the texter to get its details.
    if [ url, raw_html ].any?(&:present?) && !body_provided?
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

  def create_mp3(force: false)
    # Don't re-encoder if the content hasn't changed.
    return if !force && sha256 == Digest::SHA256.hexdigest(transcript)

    # Build the MP3 file.
    encoder = ArticleEncoder.new(self)
    return if !force && !encoder.encode

    # Publish it to S3.
    publisher = ArticlePublisher.new(encoder.sha256, encoder.mp3_filename)
    return if !force && !publisher.publish

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

  ### Class Methods ###

end
