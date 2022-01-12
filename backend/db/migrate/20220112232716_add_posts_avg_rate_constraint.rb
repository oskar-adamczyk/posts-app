# frozen_string_literal: true

class AddPostsAvgRateConstraint < ActiveRecord::Migration[6.1]
  def self.up
    add_check_constraint :posts, "average_rate BETWEEN 1 AND 5 OR average_rate = 0", name: :check_average_rate_range
  end

  def self.down
    execute <<-SQL
            ALTER TABLE posts
              DROP CONSTRAINT check_average_rate_range
    SQL
  end
end
