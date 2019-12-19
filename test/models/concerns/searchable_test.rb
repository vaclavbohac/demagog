# frozen_string_literal: true

require "test_helper"

class SearchableTest < ActiveSupport::TestCase
  class Person
    extend ActiveModel::Naming

    include Searchable
  end

  test "it should set index name" do
    assert_equal Person.index_name, "searchable_test/people_test"
  end

  test "it should extend the model by elasticsearch support" do
    subject = Person.new

    assert subject.respond_to?(:__elasticsearch__)
  end
end
