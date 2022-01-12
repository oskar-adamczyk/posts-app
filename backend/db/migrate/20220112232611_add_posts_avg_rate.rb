# frozen_string_literal: true

class AddPostsAvgRate < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :average_rate, :float
  end
end
