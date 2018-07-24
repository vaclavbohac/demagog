# frozen_string_literal: true

class PageMigration
  attr_accessor :connection
  attr_accessor :quiet

  def initialize(connection, quiet)
    self.connection = connection
    self.quiet = quiet
  end

  def perform
    # parent=31 is "Komentare a #vyrokdne", which is parent which legacy used for
    # all or non-factchecking articles. So we want all the other pages
    old_pages = self.connection.query("
      SELECT *
      FROM static_pages
      WHERE parent <> 31
    ")

    old_pages.each do |old_page|
      page = Page.new(
        title: old_page["nazov"],
        slug: old_page["alias"],
        text_html: old_page["obsah"],
        published: old_page["status"] == 1,
        created_at: old_page["timestamp"],
        updated_at: old_page["timestamp"]
      )

      page.save!
    end
  end
end
