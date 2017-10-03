# frozen_string_literal: true

require "test_helper"

class ArticleControllerTest < ActionDispatch::IntegrationTest
  test "should render fact checking" do
    get article_url(articles(:one))
    assert_response :success
  end

  test "should render static article" do
    get article_url(articles(:two))
    assert_response :success
  end
end
