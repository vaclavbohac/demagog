# frozen_string_literal: true

class UserRoleMigration
  attr_accessor :connection

  def initialize(connection)
    self.connection = connection
  end

  def perform
    old_user_roles = self.connection.query("SELECT DISTINCT usertype FROM usertype")

    old_user_roles.each do |old_user_role|
      user_role = Role.new(name: old_user_role["usertype"])
      user_role.save!
    end
  end
end
