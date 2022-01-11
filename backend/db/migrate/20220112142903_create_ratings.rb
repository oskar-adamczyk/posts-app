# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings, id: :uuid do |t|
      t.integer :rate, null: false

      t.references :post, type: :uuid, index: true, foreign_key: true, null: false

      t.datetime :deleted_at
      t.timestamps null: false

      t.check_constraint "rate BETWEEN 1 AND 5", name: :check_rate_range
    end
  end
end
