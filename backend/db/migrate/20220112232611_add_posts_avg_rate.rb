# frozen_string_literal: true

class AddPostsAvgRate < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :average_rate, :float

    add_check_constraint :posts, "average_rate BETWEEN 1 AND 5", name: :check_average_rate_range
  end
end
