# frozen_string_literal: true

class PageMigration
  attr_accessor :connection
  attr_accessor :quiet

  def initialize(connection, quiet)
    self.connection = connection
    self.quiet = quiet
  end

  def perform
    migrate_pages
    migrate_menu_items
  end

  def migrate_pages
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

  def migrate_menu_items
    MenuItem.create!(
      title: "O Demagog.cz",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "o-nas"),
      order: 0
    )
    MenuItem.create!(
      title: "Jak hodnotíme?",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "jak-hodnotime-metodika"),
      order: 1
    )
    MenuItem.create!(
      title: "Výtky k hodnocení",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "mam-vyhradu-k-hodnoceni-nebo-navrh-na-overeni-kam-se-mohu-obra"),
      order: 2
    )
    MenuItem.create!(
      title: "Naše financování",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "jak-je-projekt-demagogcz-financovan"),
      order: 3
    )
    MenuItem.create!(
      title: "Etický kodex",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "eticky-kodex-demagogcz"),
      order: 4
    )
    MenuItem.create!(
      title: "Kontakty",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "kontakty"),
      order: 5
    )
    MenuItem.create!(
      kind: MenuItem::KIND_DIVIDER,
      order: 6
    )
    MenuItem.create!(
      title: "Nabízíme workshopy",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "workshopy-demagogcz"),
      order: 7
    )
    MenuItem.create!(
      title: "Czech this out!",
      kind: MenuItem::KIND_PAGE,
      page: Page.find_by(slug: "czech-this-out"),
      order: 8
    )
  end
end
