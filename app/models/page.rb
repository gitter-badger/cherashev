class Page < ActiveRecord::Base
  enum category: [:static, :blog]
  enum state: [:draft, :published, :archived, :deleted]

  validates :title, presence: true
  validates :alias, presence: true # TODO: autogenerate I18n::transliterate(self.title)

  scope :latest, ->{order('created_at DESC')}
  scope :published, ->{where(state: Page.states[:published])}
  scope :blog_posts, ->{where(category: Page.categories[:blog])}
  scope :latest_blog_posts, ->{latest.published.blog_posts}
end
