# frozen_string_literal: true

class AddAverageRateIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :posts, "average_rate", where: "deleted_at IS NULL"
  end
end
