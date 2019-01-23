# frozen_string_literal: true

require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  MODELS = [Article, Page, Statement, Speaker, Body]

  teardown do
    elasticsearch_cleanup MODELS
  end

  test "should find speakers" do
    create(:speaker, first_name: "John", last_name: "Doe")
    create(:speaker, first_name: "Jane", last_name: "Doe")

    elasticsearch_index MODELS

    get search_index_path(query: "Doe")

    assert_response :success
    assert_select ".s-section-speakers", 1 do
      assert_select "h3"
      assert_select ".s-speaker", 2
      assert_select ".s-more", 0
    end
  end

  test "should render show more button if more than two politicians matches" do
    create_list(:speaker, 3, first_name: "John", last_name: "Doe")

    elasticsearch_index MODELS

    get search_index_path(query: "John")

    assert_response :success
    assert_select ".s-section-speakers", 1 do
      assert_select ".s-speaker", 2
      assert_select "a.s-more[href=?]", search_show_path(query: "John", type: :speakers)
    end
  end

  test "should not show speaker section if no speaker found"  do
    elasticsearch_index MODELS

    get search_index_url(query: "Doe")

    assert_response :success
    assert_select ".s-section-speakers", 0
  end

  test "should find articles" do
    create(:fact_check, title: "Lorem ipsum sit dolor")

    elasticsearch_index MODELS

    get search_index_path(query: "ipsum")

    assert_response :success
    assert_select ".s-section-articles", 1
    assert_select ".s-article", 1
  end

  test "should render show more button if more than two articles matches" do
    create_list(:fact_check, 3, title: "Lorem ipsum sit dolor")

    elasticsearch_index MODELS

    get search_index_path(query: "ipsum")

    assert_response :success
    assert_select ".s-section-articles", 1 do
      assert_select ".s-article", 2
      assert_select "a.s-more[href=?]", search_show_path(query: "ipsum", type: :articles)
    end
  end

  test "should not show articles section if no articles found"  do
    elasticsearch_index MODELS

    get search_index_path(query: "ipsum")

    assert_response :success
    assert_select ".s-section-articles", 0
  end

  test "should find statements" do
    create(:statement, content: "Integer vulputate sem a nibh rutrum consequat.")
    create(:statement, content: "Integer vulputate sem a nibh rutrum consequat.")

    elasticsearch_index MODELS

    get search_index_path(query: "rutrum")

    assert_response :success
    assert_select ".s-section-statements", 1
    assert_select ".s-statement", 2
  end

  test "should render show more button if more than two statements matches" do
    create_list(:statement, 3, content: "Integer vulputate sem a nibh rutrum consequat.")

    elasticsearch_index MODELS

    get search_index_path(query: "rutrum")

    assert_response :success
    assert_select ".s-section-statements", 1 do
      assert_select "h3"
      assert_select ".s-statement", 2
      assert_select "a.s-more[href=?]", search_show_path(query: "rutrum", type: :statements)
    end
  end

  test "should not show statements section if no statements found"  do
    elasticsearch_index MODELS

    get search_index_path(query: "ipsum")

    assert_response :success
    assert_select ".s-section-statements", 0
  end

  test "SRP should have search field pre-filled with query" do
    elasticsearch_index MODELS

    get search_index_path(query: "My query")

    assert_response :success

    assert_select ".s-search-field", 1 do
      assert_select "[value=?]", "My query"
    end
  end

  test "should render paginated list of speakers" do
    create_list(:speaker, 12, first_name: "John", last_name: "Doe")

    elasticsearch_index MODELS

    get search_show_path(query: "Doe", type: :speakers)

    assert_response :success

    assert_select ".s-search-field", 1 do
      assert_select "[value=?]", "Doe"
    end
    assert_select "a.s-back-link[href=?]", search_index_path(query: "Doe")
    assert_select "h2"
    assert_select ".s-speaker", 10
  end

  test "should render paginated list of articles" do
    create_list(:fact_check, 12, title: "Lorem ipsum")

    elasticsearch_index MODELS

    get search_show_path(query: "lorem", type: :articles)

    assert_response :success

    assert_select ".s-search-field", 1 do
      assert_select "[value=?]", "lorem"
    end
    assert_select "a.s-back-link[href=?]", search_index_path(query: "lorem")
    assert_select "h2"
    assert_select ".s-article", 10
  end

  test "should render paginated list of statements" do
    create_list(:statement, 12, content: "Integer vulputate sem a nibh rutrum consequat.")

    elasticsearch_index MODELS

    get search_show_path(query: "vulputate", type: :statements)

    assert_response :success

    assert_select ".s-search-field", 1 do
      assert_select "[value=?]", "vulputate"
    end
    assert_select "a.s-back-link[href=?]", search_index_path(query: "vulputate")
    assert_select "h2"
    assert_select ".s-statement", 10
  end
end
