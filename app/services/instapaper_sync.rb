class InstapaperSync

  attr_reader :user, :options

  def initialize(user, options = {})
    @user     = user
    @options  = options
  end

  def perform
    # Make sure we've got a user that has instapaper credentials.
    return if user.try(:instapaper) == nil

    # Get the current list of bookmarks.
    bookmarks = user.instapaper.bookmarks(have: instapaper_have_clause)

    # Lock on the user so we don't try to do this in multiple threads.
    user.with_lock do
      # Update bookmarks that already exist.
      user.articles.with_deleted.where(instapaper_bookmark_id: bookmarks.map(&:id)).each do |article|
        # Get the existing bookmark.
        bookmark = bookmarks.find { |b| b["bookmark_id"] == article.instapaper_bookmark_id }
        next unless bookmark

        # Update the existing article.
        bookmarks.delete(bookmark)
        update_article(article, bookmark)
      end

      # Create new bookmarks.
      bookmarks.each do |bookmark|
        update_article(user.articles.build, bookmark)
      end
    end
  end

  def instapaper_have_clause
    user
      .articles
      .pluck(:instapaper_bookmark_id, :instapaper_hash)
      .select { |id, hash| id.present? && hash.present? }
      .map { |id, hash| "#{ id }:#{ hash }" }
      .join(",")
  end

  def update_article(article, bookmark)
    # Get the text of the given bookmark.
    text = user.instapaper.bookmark_text(bookmark["bookmark_id"])
    return if text == nil

    # Update the article.
    article.attributes = {
      :url                    => bookmark["url"],
      :body                   => text,
      :title                  => bookmark["title"],
      :author                 => "Instapaper Author",
      :body_provided          => true,
      :instapaper_bookmark_id => bookmark["bookmark_id"],
      :instapaper_hash        => bookmark["hash"],
    }

    # Commit the article.
    article.save
  end

  def self.enqueue(user)
    new(user).delay.perform
  end

  def self.enqueue_all
    User.all.find_in_batches do |users|
      users.each do |user|
        enqueue(user)
      end
    end
  end

end
